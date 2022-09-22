//
//  DetailView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

protocol DetailViewDelegate: DetailViewController {
    func touchUpOpenButton()
}

final class DetailView: BaseView {
    
    // MARK: - UI Property
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = R.Color.white
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    lazy var openButton = NDSButton().then {
        $0.text = "앱으로 이동"
        $0.isDisabled = true
        $0.addTarget(self, action: #selector(touchUpButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var delegate: DetailViewDelegate?
    
    var hasData: Bool = false {
        didSet {
            openButton.isDisabled = hasData ? false : true
        }
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(collectionView, openButton)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Metric.navigationHeight)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        openButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Metric.ctaButtonLeading)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(Metric.ctaButtonBottom)
            make.height.equalTo(Metric.ctaButtonHeight)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpButton() {
        delegate?.touchUpOpenButton()
    }
}
