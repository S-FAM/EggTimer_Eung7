//
//  MainViewController.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import PanModal

class MainViewController: UIViewController {
    let viewModel = MainViewModel()
    let disposeBag = DisposeBag()
    var timeCount: Int = 0
    var timer = Timer()
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
        }
        return footerView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemYellow
        tableView.register(MainTableViewCell.self,
                           forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .black
        tableView.allowsSelection = false
        tableView.tableFooterView = tableFooterView
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        bind()
    }
    
    func updateNavigationTitle(_ food: Food) {
        title = food.name
    }
    
    func updateUI() {
        view.backgroundColor = .systemYellow
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
    
    func bind() {
        // TableView 설정
        viewModel.foods
            .bind(to: tableView.rx.items(
                cellIdentifier: MainTableViewCell.identifier,
                cellType: MainTableViewCell.self
            )) { [weak self] row, food, cell in
                guard let self = self else { return }
                let time = self.viewModel.secondsToMinutesSeconds(food.seconds)
                let string = self.viewModel.stringFromTime(time.0, time.1)
                cell.setData(food, string)
                
                // playButton이 선택
                cell.setTimer = {
                    self.startPauseButton.isSelected = false
                    self.timerCounting = false
                    self.timer.invalidate()
                    self.timeCount = food.seconds
                    self.timeLabel.text = string
                    self.updateNavigationTitle(food)
                }
                
                // deleteButton이 선택
                cell.deleteFood = {
                    self.viewModel.deleteFromFoods(row)
                }
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: @objc methods
extension MainViewController {
    @objc func didTapResetButton(_ sender: UIButton) {
        
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
        timeCount -= 1
        let time = viewModel.secondsToMinutesSeconds(timeCount)
        let timeString = viewModel.stringFromTime(time.0, time.1)
        print(timeString)
        timeLabel.text = timeString
    }
}
