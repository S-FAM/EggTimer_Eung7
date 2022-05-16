//
//  MainViewController.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/16.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
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
        config.baseBackgroundColor = .systemPink
        config.baseForegroundColor = .systemBackground
        
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBlue
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        updateNavigationBar()
    }
    
    func updateNavigationBar() {
        title = "Moist Yolk Egg"
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
}
