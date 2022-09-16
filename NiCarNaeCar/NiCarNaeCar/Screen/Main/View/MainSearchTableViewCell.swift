//
//  MainSearchTableViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class MainSearchTableViewCell: BaseTableViewCell {
    
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
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(25)
        }
    }
    
    // MARK: - Custom Method
    
    func setData(_ data: String) {
        titleLabel.text = data
    }
}
