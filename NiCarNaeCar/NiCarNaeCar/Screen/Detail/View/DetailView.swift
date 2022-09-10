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
    
    lazy var openButton = NDSButton().then {
        $0.text = "앱으로 이동"
        $0.isDisabled = false
        $0.addTarget(self, action: #selector(touchUpButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var delegate: DetailViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(openButton)
        
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
