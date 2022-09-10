//
//  OnboardingView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

extension Metric {
    static let ctaButtonLeading: CGFloat = 20
    static let ctaButtonBottom: CGFloat = 25
    static let ctaButtonHeight: CGFloat = 52
}

protocol OnboardingViewDelegate: OnboardingViewController {
    func touchUpStartButton()
}

final class OnboardingView: BaseView {
    
    // MARK: - UI Property
    
    private var backgrounImageView = UIImageView().then {
        $0.image = R.Image.imgBackground
        $0.contentMode = .scaleToFill
    }
    
    private var titleLabel = UILabel().then {
        $0.text = """
                  DON’T
                  SIT AT
                  HOME.
                  GO
                  FOR
                  A RIDE!
                  """
        $0.numberOfLines = 0
        $0.addLineSpacing(spacing: 85)
        $0.font = NiCarNaeCarFont.title0.font
    }
    
    lazy var startButton = NDSButton().then {
        $0.text = "시작하기"
        $0.isDisabled = false
        $0.addTarget(self, action: #selector(touchUpStartButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var delegate: OnboardingViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(backgrounImageView, titleLabel, startButton)
        
        backgrounImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(77)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(94)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(15)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(26)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metric.ctaButtonLeading)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(Metric.ctaButtonBottom)
            make.height.equalTo(Metric.ctaButtonHeight)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpStartButton() {
        delegate?.touchUpStartButton()
    }
}
