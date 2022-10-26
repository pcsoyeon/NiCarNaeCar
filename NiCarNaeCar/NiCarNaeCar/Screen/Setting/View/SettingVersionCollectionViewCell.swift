//
//  SettingVersionCollectionViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/24.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class SettingVersionCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    private var subTitleLabel = UILabel().then {
        $0.textColor = R.Color.gray200
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    private var detailLabel = UILabel().then {
        $0.textColor = R.Color.gray200
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        contentView.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(titleLabel, subTitleLabel, detailLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metric.margin)
            make.top.equalToSuperview().inset(17)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.top.equalToSuperview().inset(17)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }
    
    
    // MARK: - Data
    
    func setData(_ title: String, _ subTitle: String, _ detail: String) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        detailLabel.text = detail
    }
}
