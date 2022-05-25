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
        
        // MARK: PlusButtonTap Logic
        footerView.presentTaskVC = { [weak self] in
            guard let self = self else { return }
            let vc = TaskViewController()
            
            // MARK: ComfirmButton Logic
            vc.confirmButtonCompletion = { vm in
                self.viewModel.appendMainViewModels(vm)
                self.tableView.reloadData()
                vc.dismiss(animated: true)
            }
            self.presentPanModal(vc)
        }
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "list.triangle"),
            style: .plain,
            target: self,
            action: #selector(didTapMenuButton)
        )
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
        
        // MARK: setTimer == playButton 선택
        cell.setTimer = { [weak self] in
            self?.startPauseButton.isSelected = false
            self?.timeLabel.text = list.timeString
            self?.title = list.name
            self?.viewModel.didTapPlayButton(list)
        }

        // MARK: deleteFoodVM == deleteButton 선택
        cell.deleteFoodVM = { [weak self] in
            self?.viewModel.removeMainViewModels(indexPath.row)
            tableView.reloadData()
        }
        return cell
    }
}

// MARK: @objc Methods
extension MainViewController {
    @objc func didTapResetButton(_ sender: UIButton) {
        guard let vm = self.viewModel.currentFoodVM else { return }
        self.timeLabel.text = self.viewModel.didTapResetButton(vm) {
            self.startPauseButton.isSelected = false
            self.title = vm.name
            /// completion을 통해서 로직의 순서를 정해주고, 가독성을 높임.
        }
    }
    
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
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
    @objc func timerObserver() {
        viewModel.timerObserver() { timeLabel.text = $0 } /// completion을 통해서 로직의 순서를 정해주고, 가독성을 높임
    }
}
