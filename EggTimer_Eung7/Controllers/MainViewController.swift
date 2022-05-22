//
//  MainViewController.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import UIKit
import SnapKit
import PanModal

class MainViewController: UIViewController {
    let viewModel = MainListViewModel()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 100, weight: .bold)
        
        return label
    }()
    
    lazy var resetButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 40.0
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.addTarget(self, action: #selector(didTapResetButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var startPauseButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 40.0
        button.backgroundColor = .systemOrange
        button.setTitle("Start", for: .normal)
        button.setTitle("Pause", for: .selected)
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
        footerView.presentNewTaskVC = { [weak self] in
            guard let self = self else { return }
            let vc = NewTaskViewController()
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
        
        // MARK: playButton 선택
        cell.setTimer = { [weak self] in
            self?.startPauseButton.isSelected = false
            self?.timeLabel.text = list.timeString
            self?.title = list.food.name
            self?.viewModel.didTapPlayButton(list)
        }
        
        // MARK: deleteButton 선택
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
        guard let vm = viewModel.currentFoodVM else { return }
        timeLabel.text = viewModel.didTapResetButton(vm) {
            startPauseButton.isSelected = false
        }
    }
    
    @objc func didTapStartPauseButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected; let state = sender.isSelected
        if state {
            viewModel.timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(timerObserver),
                userInfo: nil,
                repeats: true
            )
        } else {
            viewModel.timer.invalidate()
        }
    }
    
    @objc func timerObserver() {
        if viewModel.remainingTime > 0 {
            viewModel.remainingTime -= 1
            let time = TimeManager.shared.secondsToMinutesSeconds(viewModel.remainingTime)
            let timeString = TimeManager.shared.stringFromTime(time.0, time.1)
            timeLabel.text = timeString
        }
    }
}
