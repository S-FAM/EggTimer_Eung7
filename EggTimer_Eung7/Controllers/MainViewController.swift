//
//  MainViewController.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import UIKit
import SnapKit
import PanModal

protocol MainViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class MainViewController: UIViewController {
    let viewModel = MainListViewModel()
    weak var delegate: MainViewControllerDelegate?
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 100, weight: .bold)
        
        return label
    }()
    
    lazy var resetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Reset"
        config.baseBackgroundColor = .orange
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapResetButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var startPauseButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .systemGray6
        config.baseForegroundColor = .label
        config.title = "Start"
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapStartPauseButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        
        return view
    }()
    
    lazy var tableFooterView: UIView = {
        let footerView = MainTableFooterView(frame: CGRect(
            origin: CGPoint(x: 0, y: 0),
            size: CGSize(width: UIScreen.main.bounds.width, height: 80.0))
        )
        footerView.delegate = self
        
        return footerView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemYellow
        tableView.register(MainTableViewCell.self,
                           forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.estimatedRowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = false
        tableView.tableFooterView = tableFooterView
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func updateUI() {
        view.backgroundColor = .systemYellow
        title = "What do you up to?"
        navigationController?.navigationBar.tintColor = .label
        
        [ timeLabel, resetButton, startPauseButton, bottomLineView, tableView ]
            .forEach { view.addSubview($0) }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(32)
            make.height.width.equalTo(80)
        }
        
        startPauseButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().inset(32)
            make.height.width.equalTo(80)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(startPauseButton.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bottomLineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: TableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.identifier,
            for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        let list = viewModel.mainViewModels[indexPath.row]
        cell.setData(list)
        cell.delegate = self
        return cell
    }
}

// MARK: Buttons
extension MainViewController: MainTableViewCellDelegate, MainTableFooterViewDelegate, TaskViewControllerDelegate {
    // MARK: AddButton
    func didTapAddButton() {
        let vc = TaskViewController()
        vc.delegate = self
        self.presentPanModal(vc)
    }
    
    // MARK: ConfirmButton
    func didTapConfirmButton(_ vm: MainViewModel) {
        self.viewModel.appendMainViewModels(vm)
        self.tableView.reloadData()
    }
    
    // MARK: DeleteButton
    func didTapDeleteButton(_ vm: MainViewModel) {
        guard let index = viewModel.mainViewModels.firstIndex(where: { $0.name == vm.name }) else { return }
        viewModel.removeMainViewModels(vm)
        deleteAnimation(index)
    }
    
    private func deleteAnimation(_ index: Int) {
        for i in index...viewModel.mainViewModels.count {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                cell.frame.origin.y -= cell.frame.height
            }, completion: { done in
                if done { self.tableView.reloadData() }
            })
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.tableFooterView.frame.origin.y -= self.tableView.visibleCells[0].frame.height
        }, completion: nil)
    }
    
    // MARK: PlayButton
    func didTapPlayButton(_ vm: MainViewModel) {
        startPauseButton.isSelected = false
        timeLabel.text = vm.timeString
        title = vm.name
        viewModel.didTapPlayButton(vm)
    }
    
    // MARK: ResetButton
    @objc func didTapResetButton(_ sender: UIButton) {
        guard let vm = self.viewModel.currentFoodVM else { return }
        self.timeLabel.text = self.viewModel.didTapResetButton(vm) {
            self.startPauseButton.isSelected = false
            self.title = vm.name
        }
    }
    
    // MARK: StartPauseButton
    @objc func didTapStartPauseButton(_ sender: UIButton) {
        guard let currentFoodVM = viewModel.currentFoodVM else { return }
        sender.isSelected = !sender.isSelected; let state = sender.isSelected
        if state {
            sender.setTitle("Pause", for: .selected)
            title = String(format: "⏰ %@ ⏰", currentFoodVM.name)
            viewModel.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(timerObserver),
                userInfo: nil,
                repeats: true
            )
        } else {
            sender.setTitle("Start", for: .normal)
            title = currentFoodVM.name
            viewModel.timer.invalidate()
        }
    }
}

// MARK: Enter BackGround or ForeGround
extension MainViewController: timeDelivery {
    func sceneDidEnterBackground() {
        viewModel.timer.invalidate()
    }
    
    func sceneWillEnterForeground(_ interval: Int) {
        viewModel.remainingTime -= interval
        viewModel.timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(timerObserver),
            userInfo: nil,
            repeats: true
        )
    }
}

// MARK: TimeObserver
extension MainViewController {
    @objc func timerObserver() {
        viewModel.timerObserver() { timeLabel.text = $0 }
    }
}

