//
//  SettingTableViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/15.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class SettingTableViewCell: BaseTableViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    private var subTitleLabel = UILabel().then {
        $0.textColor = R.Color.gray200
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        contentView.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(titleLabel, subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Custom Method
    
    func setData(_ title: String, _ subTitle: String?) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
