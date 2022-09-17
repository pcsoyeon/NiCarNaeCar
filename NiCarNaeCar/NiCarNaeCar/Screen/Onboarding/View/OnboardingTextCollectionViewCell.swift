//
//  OnboardingGuideView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/10.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class OnboardingTextCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - UI Property
    
    private let titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title1.font
        $0.text = """
                  서울시 나눔카 정보
                  니카내카에서 한눈에 확인하세요
                  """
        $0.numberOfLines = 0
    }
    
    private let subTitleLabel = UILabel().then {
        $0.textColor = R.Color.gray100
        $0.font = NiCarNaeCarFont.body7.font
        $0.text = "나눔카 위치 정보뿐만 아니라 예약현황까지 알 수 있어요"
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        contentView.addSubviews(titleLabel, subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(126)
            make.leading.equalToSuperview().inset(Metric.margin)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.margin)
        }
    }
}
