//
//  SettingNameController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/17.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class SettingNameController: BaseViewController {
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.backButtonIsHidden = true
    }
    
    private var nameTextField = NDSTextField().then {
        $0.isFocusing = true
    }
    
    private var nameCountLabel = UILabel().then {
        $0.text = "0/0"
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body7.font
    }
    
    private lazy var changeButton = NDSButton().then {
        $0.text = "수정하기"
        $0.isDisabled = false
        $0.addTarget(self, action: #selector(touchUpChangeButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = R.Color.white
        configureNavigation()
        configureTextField()
    }
    
    override func setLayout() {
        super.setLayout()
        view.addSubviews(navigationBar, nameTextField, nameCountLabel, changeButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(35)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.ctaButtonLeading)
        }
        
        nameCountLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(16)
        }
        
        changeButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.ctaButtonLeading)
            make.height.equalTo(Metric.ctaButtonHeight)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-Metric.ctaButtonBottom)
        }
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureTextField() {
        nameTextField.becomeFirstResponder()
        
        nameTextField.delegate = self
        
        guard let name = UserDefaults.standard.string(forKey: Constant.UserDefaults.userName) else { return }
        nameTextField.text = name
    }
    
    // MARK: - @objc
    
    @objc func touchUpChangeButton() {
        if let text = nameTextField.text {
            UserDefaults.standard.setValue(text, forKey: Constant.UserDefaults.userName)
            dismiss(animated: true)
        }
    }
}

// MARK: - UITextField Protocol

extension SettingNameController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = nameTextField.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty || text == nameTextField.placeholder {
            navigationBar.isCloseButtonDisabled = true
            changeButton.isDisabled = true
            nameCountLabel.textColor = R.Color.gray200
        } else {
            navigationBar.isCloseButtonDisabled = false
            changeButton.isDisabled = false
        }
        nameCountLabel.text = "\(text.count)/10"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        return !(newLength > 10)
    }
}
