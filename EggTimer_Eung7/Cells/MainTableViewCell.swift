//
//  MainTableViewCell.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/17.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainTableViewCell: UITableViewCell {
    static let identifier = "MainTableViewCell"
    let disposeBag = DisposeBag()
    var deleteFood: () -> Void = {}
    var setTimer: () -> Void = {}
    
    lazy var playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.circle")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 24)
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        
        return button
    }()
    
    lazy var deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "trash")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 14)
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        
        return button
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .light)
        
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18.0, weight: .light)
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    func setData(_ food: Food, _ timeString: String) {
        nameLabel.text = food.name
        timeLabel.text = timeString
    }
    
    func setupUI() {
        contentView.backgroundColor = .systemFill
        
        [ playButton, timeLabel, nameLabel, deleteButton ]
            .forEach { contentView.addSubview($0) }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(playButton.snp.leading).offset(-8)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(deleteButton.snp.trailing).offset(4)
        }
    }
}

extension MainTableViewCell {
    @objc func didTapDeleteButton() {
        deleteFood()
    }
    
    @objc func didTapPlayButton() {
        setTimer()
    }
}
