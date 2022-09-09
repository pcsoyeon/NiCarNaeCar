//
//  OnboardingNameView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

protocol OnboardingNameViewDelegate: OnboardingNameViewController {
    func touchUpStartButton()
}

final class OnboardingNameView: BaseView {
    
    // MARK: - UI Property
    
    var nameTextField = NDSTextField().then {
        $0.placeholder = "니캉내캉"
        $0.isFocusing = true
    }
    
    var nameCountLabel = UILabel().then {
        $0.text = "0/0"
        $0.textColor = R.Color.black200
    }
    
    lazy var startButton = NDSButton().then {
        $0.text = "시작하기"
        $0.isDisabled = false
        $0.addTarget(self, action: #selector(touchUpStartButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var delegate: OnboardingNameViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(nameTextField, nameCountLabel, startButton)
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(152)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.ctaButtonLeading)
        }
        
        nameCountLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(16)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.ctaButtonLeading)
            make.height.equalTo(Metric.ctaButtonHeight)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).inset(-Metric.ctaButtonBottom)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpStartButton() {
        delegate?.touchUpStartButton()
    }
}