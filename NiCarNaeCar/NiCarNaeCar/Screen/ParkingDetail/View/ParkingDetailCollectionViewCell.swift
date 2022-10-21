//
//  ParkingDetailCollectionViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/19.
//

import UIKit

import SnapKit
import Then

import NiCarNaeCar_Util
import NiCarNaeCar_Resource


final class ParkingDetailCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body3.font
    }
    
    private var detailLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body4.font
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        contentView.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(titleLabel, detailLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(Metric.margin)
            make.centerY.equalToSuperview()
        }
        
        detailLabel.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(Metric.margin)
            make.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Data
    
    func setData(_ title: String, _ detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}
