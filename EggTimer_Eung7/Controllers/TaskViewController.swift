//
//  NewTaskViewController.swift
//  EggTimer_Eung7
//
//  Created by 김응철 on 2022/05/17.
//

import UIKit
import SnapKit
import PanModal

protocol TaskViewControllerDelegate: AnyObject {
    func didTapConfirmButton(_ vm: MainViewModel)
}

class TaskViewController: UIViewController {
    var viewModel = TaskViewModel()
    weak var delegate: TaskViewControllerDelegate?
    
    var keyboardHeight: CGFloat = 300
    var confirmButtonCompletion: ((MainViewModel) -> Void)?
    
    lazy var confirmButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Confirm"
        config.attributedTitle?.font = .systemFont(ofSize: 18.0, weight: .medium)
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .systemCyan
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapConfirmButton(_:)), for: .touchUpInside)
        
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Cancel"
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .systemRed
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
        setKeyboardObserver()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setKeyboardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyBoardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
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
            make.top.equalTo(taskTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
    }
}

// MARK: Button Methods
extension TaskViewController {
    @objc func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func didTapConfirmButton(_ sender: UIButton) {
        guard let text = taskTextField.text,
              let minutes = viewModel.minutes,
              let seconds = viewModel.seconds else { return }
        let mainVM = viewModel.didTapConfirmButton(text, minutes: minutes, seconds: seconds)
        delegate?.didTapConfirmButton(mainVM)
        dismiss(animated: true)
    }
}

// MARK: TextField Delegate
extension TaskViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""; textField.textColor = .label
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true); return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
    
        return updatedText.count <= 40
    }
}

// MARK: PickerView Controller
extension TaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRowsInComponent
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.titles[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == minutePickerView {
            viewModel.minutes = viewModel.pickerViewlist[row]
        } else if pickerView == secondsPickerView {
            viewModel.seconds = viewModel.pickerViewlist[row]
        }
    }
}

// MARK: PanModal Controller
extension TaskViewController: PanModalPresentable {
    var panScrollable: UIScrollView? { return nil }
    var shortFormHeight: PanModalHeight { return .contentHeight(300) }
    var longFormHeight: PanModalHeight { return .contentHeight(keyboardHeight + 180) }
}

// MARK: Keyboard methods
private extension TaskViewController {
    @objc func keyboardWillShow(_ noti: Notification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let height = keyboardRectangle.height
            keyboardHeight = height
            self.panModalTransition(to: .longForm)
        }
    }
    
    @objc func keyBoardWillHide(_ noti: Notification) {
        self.panModalTransition(to: .shortForm)
    }
}
