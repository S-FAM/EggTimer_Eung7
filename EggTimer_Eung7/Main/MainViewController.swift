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
    let viewModel = MainViewModel()
    var currentFood: Food?
    var timer = Timer()
    var remainingTime: Int = 0
    var timerCounting: Bool = false
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = .systemFont(ofSize: 100, weight: .bold)
        
        return label
    }()
    
    lazy var resetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Reset"
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapResetButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var startPauseButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .systemPink
        config.baseForegroundColor = .systemBackground
        config.titleAlignment = .center
        config.cornerStyle = .large
        
        let button = UIButton(configuration: config)
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
            self.presentPanModal(vc)
            
            vc.confirmButtonCompletion = { [weak self] name, minutes, seconds in
                guard let self = self else { return }
                let food = self.viewModel.createFood(name, minutes: minutes, seconds: seconds)
                self.viewModel.addFood(food)
            }
        }
        return footerView
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemTeal
        tableView.register(MainTableViewCell.self,
                           forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.estimatedRowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.allowsSelection = false
        tableView.tableFooterView = tableFooterView
        tableView.dataSource = self
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Data가 변화되었을 때 reloadTableView
        viewModel.reloadCompletion = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func updateNavigationTitle(_ food: Food) {
        title = food.name
    }
    
    func updateUI() {
        view.backgroundColor = .systemTeal
        title = "What do you up to?"
        
        [ timeLabel, resetButton, startPauseButton, bottomLineView, tableView ]
            .forEach { view.addSubview($0) }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(64)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(32)
            make.width.equalTo(80)
        }
        
        startPauseButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(32)
            make.trailing.equalToSuperview().inset(32)
            make.width.equalTo(80)
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
        return viewModel.foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.identifier,
            for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        let food = viewModel.foods[indexPath.row]
        let time = self.viewModel.secondsToMinutesSeconds(food.seconds)
        let string = self.viewModel.stringFromTime(time.0, time.1)
        cell.setData(food, string)
        
        // playButton 선택
        cell.setTimer = {
            self.startPauseButton.isSelected = false
            self.timerCounting = false
            self.timer.invalidate()
            
            self.currentFood = food
            self.remainingTime = food.seconds
            self.timeLabel.text = string
            self.updateNavigationTitle(food)
        }
        
        // deleteButton 선택
        cell.deleteFood = { [weak self] in
            guard let self = self else { return }
            self.viewModel.removeFood(indexPath.row)
        }
        return cell
    }
}

// MARK: @objc Methods
extension MainViewController {
    @objc func didTapResetButton(_ sender: UIButton) {
        guard let currentFood = currentFood else { return }
        remainingTime = currentFood.seconds
        let time = viewModel.secondsToMinutesSeconds(currentFood.seconds)
        let stringTime = viewModel.stringFromTime(time.0, time.1)
        startPauseButton.isSelected = false
        timerCounting = false
        timer.invalidate()
        timeLabel.text = stringTime
    }
    
    @objc func didTapStartPauseButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if timerCounting {
            timerCounting = false
            timer.invalidate()
        } else {
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(timerObserver),
                                         userInfo: nil,
                                         repeats: true)
        }
    }

    @objc func timerObserver() {
        if remainingTime > 0 {
            remainingTime -= 1
            let time = viewModel.secondsToMinutesSeconds(remainingTime)
            let timeString = viewModel.stringFromTime(time.0, time.1)
            timeLabel.text = timeString
        }
    }
}
