//
//  ParkingDetailLocationCollectionViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/19.
//

import UIKit

import SnapKit
import Then

import NiCarNaeCar_Util
import NiCarNaeCar_Resource


final class ParkingDetailLocationCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var nameLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title2.font
    }
    
    private var locationLabel = UILabel().then {
        $0.textColor = R.Color.gray100
        $0.font = NiCarNaeCarFont.body6.font
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        contentView.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(nameLabel, locationLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(Metric.margin)
            make.top.equalTo(contentView.safeAreaLayoutGuide).inset(30)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).inset(Metric.margin)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
    }
    
    // MARK: - Data
    
    func setData(_ name: String, _ location: String) {
        nameLabel.text = name
        locationLabel.text = location
    }
}

