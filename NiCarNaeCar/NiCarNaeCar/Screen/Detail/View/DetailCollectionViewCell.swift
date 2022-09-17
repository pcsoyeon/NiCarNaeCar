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
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = R.Color.gray100
        $0.font = NiCarNaeCarFont.body7.font
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
        contentView.addSubviews(titleLabel, subTitleLabel, countLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
    
    // MARK: - Data Bind
    
    func setData(_ brandType: BrandType, _ title: String, _ subTitle: String?, _ count: String?, _ row: Int) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        
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
