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
import PanModal

class NewTaskViewController: UIViewController {
    let viewModel = NewTaskViewModel()
    let disposeBag = DisposeBag()
    var minutes: Int?
    var seconds: Int?
    var confirmButtonCompletion: ((String, Int, Int) -> Void)?
    
    lazy var confirmButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Confirm"
        config.attributedTitle?.font = .systemFont(ofSize: 18.0, weight: .medium)
        config.baseBackgroundColor = .clear
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapConfirmButton(_:)), for: .touchUpInside)
        
        return button
    }()

    lazy var cancelButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Cancel"
        config.baseBackgroundColor = .clear
        config.attributedTitle?.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapCancelButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    var mainLabel: UILabel = {
        let label = UILabel()
        label.text = "New Task"
        label.font = .systemFont(ofSize: 20.0, weight: .medium)
        
        return label
    }()
    
    var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "What is your task?"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        return label
    }()
    
    lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Type here"
        textField.textColor = .secondaryLabel
        textField.delegate = self
        
        return textField
    }()
    
    var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        
        return view
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "How long will you do?"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        return label
    }()
    
    var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    lazy var minutePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .clear
        pickerView.dataSource = self
        pickerView.delegate = self
        
        return pickerView
    }()
    
    lazy var secondsPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .clear
        pickerView.dataSource = self
        pickerView.delegate = self
        
        return pickerView
    }()
    
    var minutesLabel: UILabel = {
        let label = UILabel()
        label.text = "minutes"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        return label
    }()
    
    var secondsLabel: UILabel = {
        let label = UILabel()
        label.text = "seconds"
        label.font = .systemFont(ofSize: 18.0, weight: .medium)
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    func setupUI() {
        view.backgroundColor = .systemGray
        
        [ minutePickerView, minutesLabel, secondsPickerView, secondsLabel ]
            .forEach { horizontalStackView.addArrangedSubview($0) }
        
        [
            cancelButton,
            confirmButton,
            mainLabel,
            taskLabel,
            bottomLineView,
            taskTextField,
            timeLabel,
            horizontalStackView
        ]
            .forEach { view.addSubview($0) }
        
        cancelButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.centerY.equalTo(confirmButton)
            make.centerX.equalToSuperview()
        }
        
        taskLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(cancelButton.snp.bottom).offset(32)
        }
        
        taskTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(taskLabel.snp.bottom).offset(8)
        }
        
        bottomLineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(taskTextField.snp.bottom).offset(4)
            make.height.equalTo(0.5)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(taskTextField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(16)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
    }
}

// MARK: @objc methods
extension NewTaskViewController {
    @objc func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func didTapConfirmButton(_ sender: UIButton) {
        guard let text = taskTextField.text,
              let minutes = minutes,
              let seconds = seconds else { return }
        confirmButtonCompletion?(text, minutes, seconds)
        dismiss(animated: true)
    }
}

// MARK: TextField Delegate
extension NewTaskViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}

// MARK: PickerView Controller
extension NewTaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.pickerViewNumberOfRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.listToString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == minutePickerView {
            minutes = viewModel.list[row]
        } else if pickerView == secondsPickerView {
            seconds = viewModel.list[row]
        }
    }
}

// MARK: PanModal Controller
extension NewTaskViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(460)
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(460)
    }
}
