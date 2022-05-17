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
    
    var playButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "play.circle")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    var deleteButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "trash")
        config.baseForegroundColor = .label
        config.baseBackgroundColor = .clear
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        
        let button = UIButton(configuration: config)
        
        return button
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "ddddd"
        
        return label
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "dasdf"
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUI()
        bind()
    }
    
    func setData(_ something: Something) {
        nameLabel.text = something.name
        timeLabel.text = "\(something.time)"
    }
    
    func updateUI() {
        contentView.backgroundColor = .systemYellow
        
        [ playButton, timeLabel, nameLabel, deleteButton ]
            .forEach { contentView.addSubview($0) }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
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
            make.leading.equalTo(deleteButton.snp.trailing).offset(8)
        }
    }
    
    func bind() {
        
    }
}
