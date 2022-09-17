//
//  NDSTextField.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

extension Metric {
    static let textFieldHeight = 36
}

final class NDSTextField: UITextField {
    
    // MARK: - UI Property
    
    private var lineView = UIView().then {
        $0.backgroundColor = R.Color.black200
    }
    
    // MARK: - Property
    
    public var isFocusing: Bool = false {
        didSet { setState() }
    }
    
    public override var placeholder: String? {
        didSet { setPlaceholder() }
    }
    
    // MARK: - Initialize
    
    public init() {
        super.init(frame: .zero)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set UI
    
    private func setUI() {
        tintColor = R.Color.black200
        backgroundColor = R.Color.white
        setupPadding()
        setState()
    }
    
    private func setLayout() {
        addSubviews(lineView)
        
        snp.makeConstraints { make in
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setState() {
        borderStyle = .none
        
        if isFocusing {
            layer.borderColor = R.Color.black200.cgColor
        }
    }
    
    private func setPlaceholder() {
        guard let placeholder = placeholder else {
            return
        }

        attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: R.Color.gray200]
        )
    }
    
}
