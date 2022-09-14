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
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = R.Color.white
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
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
        addSubviews(collectionView, startButton)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.safeAreaLayoutGuide)
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
