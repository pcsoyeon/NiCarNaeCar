//
//  OnboardingNameViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class OnboardingNameViewController: BaseViewController {

    // MARK: - UI Property
    
    let rootView = OnboardingNameView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.nameTextField.becomeFirstResponder()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureButton()
        configureTextField()
    }
    
    override func setLayout() {
        
    }
    
    private func configureButton() {
        rootView.delegate = self
    }
    
    private func configureTextField() {
        rootView.nameTextField.delegate = self
    }
}

// MARK: - Custom Delegate

extension OnboardingNameViewController: OnboardingNameViewDelegate {
    func touchUpStartButton() {
        transition(MainViewController(), transitionStyle: .presentFullScreen)
    }
}

// MARK: - UITextField Protocol

extension OnboardingNameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = rootView.nameTextField.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty || text == rootView.nameTextField.placeholder {
            rootView.startButton.isDisabled = true
            rootView.nameCountLabel.textColor = R.Color.gray200
        } else {
            rootView.startButton.isDisabled = false
        }
        rootView.nameCountLabel.text = "\(text.count)/10"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.count)! + string.count - range.length
        return !(newLength > 10)
    }
}
