//
//  NewTaskViewController.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/17.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class NewTaskViewController: UIViewController {
    let viewModel = NewTaskViewModel()
    let disposeBag = DisposeBag()
    
    var leftBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "Cancel"
        
        return barButtonItem
    }()
    
    var rightBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.title = "Confirm"
        
        return barButtonItem
    }()
    
    var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "What is your task?"
        
        return label
    }()
    
    var taskTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Type here"
        textField.textColor = .tertiarySystemGroupedBackground
        
        return textField
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "How long will you do?"
        
        return label
    }()
    
    var minutePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    var secondPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navigationItem.title = "New Task"
    }
}
