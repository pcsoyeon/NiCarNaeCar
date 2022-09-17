//
//  CloseButton.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Resource

import SnapKit

final class CloseButton: UIButton {
    
    // MARK: - Property
    
    var isDisabled: Bool = false {
        didSet {
            self.isHidden = isDisabled
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
    
    convenience init(root: UIViewController) {
        self.init()
        setAction(vc: root)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        setImage(R.Image.btnClose, for: .normal)
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
    }
    
    // MARK: - Custom Method
    
    private func setAction(vc: UIViewController) {
        let closeAction = UIAction { action in
            vc.dismiss(animated: true)
        }
        self.addAction(closeAction, for: .touchUpInside)
    }
}
