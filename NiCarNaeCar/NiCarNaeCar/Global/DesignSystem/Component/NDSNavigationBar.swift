//
//  NDSNavigationBar.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Resource

import SnapKit
import Then

final class NDSNavigationBar: UIView {
    
    // MARK: - Properties
    
    private var viewController = UIViewController()
    public var backButton = BackButton()
    private var closeButton = CloseButton()
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.textAlignment = .center
        $0.font = NiCarNaeCarFont.title2.font
    }
    
    private var detailTitleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.textAlignment = .center
        $0.font = NiCarNaeCarFont.body2.font
        $0.isHidden = true
    }
    
    var backButtonIsHidden: Bool = true {
        didSet {
            backButton.isHidden = backButtonIsHidden
        }
    }
    
    var closeButtonIsHidden: Bool = true {
        didSet {
            closeButton.isHidden = closeButtonIsHidden
        }
    }
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
            detailTitleLabel.text = title
        }
    }
    
    var isCloseButtonDisabled = true {
        didSet {
            closeButton.isDisabled = isCloseButtonDisabled
        }
    }
    
    var isDetail: Bool = false {
        didSet {
            if isDetail {
                titleLabel.isHidden = true
                detailTitleLabel.isHidden = false
            } else {
                titleLabel.isHidden = false
                detailTitleLabel.isHidden = true
            }
        }
    }
    
    // MARK: - Initializer
    
    public init(_ viewController: UIViewController) {
        super.init(frame: .zero)
        self.backButton = BackButton(root: viewController)
        self.closeButton = CloseButton(root: viewController)
        configureUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        backgroundColor = R.Color.white
    }
    
    private func setLayout() {
        addSubviews(backButton, titleLabel, detailTitleLabel, closeButton)
                
        snp.makeConstraints { make in
            make.height.equalTo(Metric.navigationHeight)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(Metric.navigationButtonLeading)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.navigationTitleTop)
            make.leading.equalToSuperview().inset(Metric.navigationTitleLeading)
        }
        
        detailTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Metric.navigationTitleTop)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.navigationButtonTrailing)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
    }
}
