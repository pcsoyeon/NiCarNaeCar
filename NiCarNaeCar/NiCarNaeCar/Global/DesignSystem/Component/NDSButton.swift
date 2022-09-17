//
//  NDSButton.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class NDSButton: UIButton {
    
    // MARK: - Property
    
    var text: String? = nil {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    
    var isDisabled: Bool = false {
        didSet {
            self.isEnabled = !isDisabled
            setBackgroundColor()
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTitle()
        setBackgroundColor()
        makeRound()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - InitUI
    
    private func setTitle() {
        titleLabel?.font = NiCarNaeCarFont.body2.font
        setTitleColor(R.Color.white, for: .normal)
        setTitleColor(R.Color.gray100, for: .highlighted)
    }
    
    private func setBackgroundColor() {
        backgroundColor = isDisabled ? R.Color.gray300 : R.Color.black200
    }
}
