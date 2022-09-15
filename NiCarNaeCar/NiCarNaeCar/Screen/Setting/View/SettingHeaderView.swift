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

final class SettingHeaderView: UIView {
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title2.font
    }
    
    private var subTitleLabel = UILabel().then {
        $0.textColor = R.Color.gray100
        $0.font = NiCarNaeCarFont.body7.font
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = R.Color.gray400
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = R.Color.white
    }
    
    private func setLayout() {
        addSubviews(titleLabel, subTitleLabel, lineView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(11)
            make.leading.equalToSuperview().inset(25)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setData(title: String, subTitle: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
