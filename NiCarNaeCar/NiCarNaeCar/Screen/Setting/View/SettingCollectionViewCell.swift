//
//  SettingCollectionViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/24.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class SettingCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        contentView.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Metric.margin)
            make.centerY.equalToSuperview()
        }
    }
    
    
    // MARK: - Data 
    
    func setData(_ title: String) {
        titleLabel.text = title
    }
}
