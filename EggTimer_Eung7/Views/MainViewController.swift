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
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "07:00"
        label.font = .systemFont(ofSize: 100, weight: .bold)
        
        return label
    }()
    
    var resetButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Reset"
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    var startButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Start"
        config.baseBackgroundColor = .black
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        
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
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
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
        
        [ timeLabel, resetButton, startButton, bottomLineView, tableView ]
            .forEach { view.addSubview($0) }
        
        timeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
        
        resetButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(32)
        }
        
        startButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(32)
            make.trailing.equalToSuperview().inset(32)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.top.equalTo(startButton.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(bottomLineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func bind() {
        viewModel.foods
            .bind(to: tableView.rx.items(
                cellIdentifier: MainTableViewCell.identifier,
                cellType: MainTableViewCell.self
            )) { row, food, cell in
                cell.setData(food)
                
                cell.setTimer = { [weak self] in
                    guard let self = self else { return }
                    self.timeLabel.text = "\(food.time)"
                    self.updateNavigationTitle(food)
                }
                
                cell.deleteFood = { [weak self] in
                    guard let self = self else { return }
                    self.viewModel.deleteFromFoods(row)
                }
            }
            .disposed(by: disposeBag)
    }
}
