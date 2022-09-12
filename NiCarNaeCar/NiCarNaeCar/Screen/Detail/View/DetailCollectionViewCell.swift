//
//  DetailCollectionViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/12.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class DetailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private let titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body3.font
    }
    
    private let countLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body3.font
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        contentView.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(titleLabel, countLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(25)
        }
    }
    
    // MARK: - Data Bind
    
    func setData(_ brandType: BrandType, _ title: String, _ count: String?, _ row: Int) {
        titleLabel.text = title
        
        if row == 0 {
            titleLabel.font = NiCarNaeCarFont.body2.font
        }
        
        if let count = count {
            countLabel.text = "\(count)"
            if row == 2 {
                countLabel.textColor = brandType.color
            }
        }
        
    }
}
