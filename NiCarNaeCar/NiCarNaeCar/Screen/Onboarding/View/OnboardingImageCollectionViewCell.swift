//
//  OnboardingCollectionViewCell.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/10.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class OnboardingImageCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private var backgroundImageView = UIImageView().then {
        $0.image = R.Image.imgBackground
        $0.contentMode = .scaleAspectFill
    }
    
    private var titleLabel = UILabel().then {
        $0.text = """
                  필요할 때
                  언제
                  어디서나

                  내차처럼
                  편리하게
                  """
        $0.numberOfLines = 0
        $0.addLineSpacing(spacing: 85)
        $0.font = NiCarNaeCarFont.title05.font
        $0.textColor = R.Color.black200
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(backgroundImageView, titleLabel)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(77)
            make.bottom.equalToSuperview().inset(94)
            make.leading.trailing.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(100)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
    }
}
