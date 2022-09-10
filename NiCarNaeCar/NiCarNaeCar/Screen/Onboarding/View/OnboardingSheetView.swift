//
//  OnboardingSheetView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/10.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

protocol OnboardingSheetViewDelegate: OnboardingSheetViewController {
    func touchUpStartButton()
}

final class OnboardingSheetView: BaseView {
    
    // MARK: - UI Property
    
    private lazy var startButton = NDSButton().then {
        $0.text = "계속하기"
        $0.isDisabled = false
        $0.addTarget(self, action: #selector(touchUpStartButton), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = """
                  앱 사용을 위해 권한을 허용해주세요
                  꼭 필요한 권한만 받아요
                  """
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title3.font
        $0.numberOfLines = 0
    }
    
    private let imageView = UIImageView().then {
        $0.backgroundColor = R.Color.gray400
        $0.makeRound()
    }
    
    private let locationLabel = UILabel().then {
        $0.text = "위치"
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body2.font
    }
    
    private let locationDescriptionLabel = UILabel().then {
        $0.text = """
                  현재 위치를 지도에 표시하고
                  가까운 거리의 나눔카 정보를 확인할 수 있습니다
                  """
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body7.font
        $0.addLabelSpacing(fontStyle: NiCarNaeCarFont.body7)
        $0.numberOfLines = 0
    }
    
    // MARK: - Property
    
    weak var delegate: OnboardingSheetViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(titleLabel, imageView, locationLabel, locationDescriptionLabel, startButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(29)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(25)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(25)
            make.width.height.equalTo(37)
        }
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.equalTo(imageView.snp.trailing).offset(16)
        }
        
        locationDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(12)
            make.leading.equalTo(locationLabel.snp.leading)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.ctaButtonLeading)
            make.height.equalTo(Metric.ctaButtonHeight)
            make.bottom.equalTo(self.keyboardLayoutGuide.snp.top).inset(-Metric.ctaButtonBottom)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpStartButton() {
        delegate?.touchUpStartButton()
    }
}
