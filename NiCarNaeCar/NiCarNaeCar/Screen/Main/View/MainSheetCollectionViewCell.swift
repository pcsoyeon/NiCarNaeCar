//
//  MainSheetCollectionViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/10.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class MainSheetCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var logoImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private var titleLabel = UILabel().then {
        $0.font = NiCarNaeCarFont.body4.font
    }
    
    private var countLabel = UILabel().then {
        $0.font = NiCarNaeCarFont.body2.font
    }

    // MARK: - Property
    
    var carType: CarType = .socar {
        didSet {
            logoImageView.image = carType.logoImage
            titleLabel.text = carType.title
            titleLabel.textColor = carType.color
        }
    }
    
    // MARK: - UI Method
    
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? carType.color.cgColor : R.Color.gray400.cgColor
        }
    }
    
    override func configureUI() {
        contentView.layer.borderColor = R.Color.gray400.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
    }
    
    override func setLayout() {
        contentView.addSubviews(logoImageView, titleLabel, countLabel)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(22)
            make.width.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Data Bind
    
    func setData(_ carType: CarType, _ count: Int) {
        self.carType = carType
        
        countLabel.text = "\(count)대 예약가능"
    }
}
