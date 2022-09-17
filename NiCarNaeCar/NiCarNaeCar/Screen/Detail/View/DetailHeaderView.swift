//
//  DetailHeaderView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/12.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class DetailHeaderView: UICollectionReusableView {
    
    static var identifier: String { return String(describing: self) }
    
    // MARK: - Properties
    
    private var logoImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private var logoLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title2.font
    }
    
    private var carTypeLabel = UILabel().then {
        $0.textColor = R.Color.gray100
        $0.font = NiCarNaeCarFont.body7.font
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = R.Color.gray400
    }
    
    // MARK: - Property
    
    var brandType: BrandType = .socar {
        didSet {
            logoImageView.image = brandType.logoImage
            logoLabel.text = brandType.brandNameEN
        }
    }
    
    var carType: String = "" {
        didSet {
            carTypeLabel.text = carType
        }
    }
    
    // MARK: - Initialzier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Init UI
    
    private func configureUI() {
        backgroundColor = R.Color.white
    }
    
    private func setLayout() {
        addSubviews(logoImageView, logoLabel, carTypeLabel, lineView)
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.margin)
            make.width.height.equalTo(60)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.leading.equalTo(logoImageView.snp.trailing).offset(16)
        }
        
        carTypeLabel.snp.makeConstraints { make in
            make.top.equalTo(logoLabel.snp.bottom).offset(5)
            make.leading.equalTo(logoImageView.snp.trailing).offset(16)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(24)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(10)
        }
    }
}
