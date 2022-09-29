//
//  SettingHeaderView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/15.
//

import UIKit

import NiCarNaeCar_Resource

import SnapKit
import Then

protocol SettingHeaderViewDelegate: SettingViewController {
    func touchUpButton()
}

final class SettingHeaderView: UIView {
    
    // MARK: - UI Property
    
    private var nameLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title2.font
    }
    
    private lazy var changeNameButton = UIButton().then {
        $0.setTitle("내 정보 수정하기", for: .normal)
        $0.setTitleColor(R.Color.gray100, for: .normal)
        $0.setTitleColor(R.Color.black200, for: .highlighted)
        $0.titleLabel?.font = NiCarNaeCarFont.body7.font
        $0.addTarget(self, action: #selector(touchUpButton), for: .touchUpInside)
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = R.Color.gray400
    }
    
    // MARK: - Property
    
    weak var delegate: SettingHeaderViewDelegate?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        backgroundColor = R.Color.white
    }
    
    private func setLayout() {
        addSubviews(nameLabel, changeNameButton, lineView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        changeNameButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        lineView.snp.makeConstraints { make in
            make.height.equalTo(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpButton() {
        delegate?.touchUpButton()
    }
    
    // MARK: - Custom Method
    
    func setData(_ name: String) {
        nameLabel.text = name
    }
}
