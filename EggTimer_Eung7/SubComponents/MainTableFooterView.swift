//
//  MainTableFooterView.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/17.
//

import UIKit
import SnapKit

class MainTableFooterView: UITableViewHeaderFooterView {
    var presentNewTaskVC: () -> Void = {}
    
    lazy var addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .black
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return button
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
    }
    
    func setupUI() {
        addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
}

extension MainTableFooterView {
    @objc func didTapAddButton() {
        presentNewTaskVC()
    }
}
