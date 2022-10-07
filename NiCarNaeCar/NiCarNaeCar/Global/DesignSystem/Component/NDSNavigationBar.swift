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
    
    // MARK: - PageView Enum
    
    public enum PageView {
        case main
        case detail
        case setting
        
        fileprivate var title: String? {
            switch self {
            case .main:
                return ""
            case .detail:
                return "예약 현황"
            case .setting:
                return "설정"
            }
        }
    }
    
    // MARK: - Properties
    
    private var viewController = UIViewController()
    public var backButton = BackButton()
    private var closeButton = CloseButton()
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.textAlignment = .center
        $0.font = NiCarNaeCarFont.body2.font
    }
    
    var viewType: PageView = .main {
        didSet {
            titleLabel.text = viewType.title
        }
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
        }
    }
    
    var isCloseButtonDisabled = true {
        didSet {
            closeButton.isDisabled = isCloseButtonDisabled
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
    
    convenience init(_ viewController: UIViewController,
                     view: PageView,
                     isHidden: Bool) {
        self.init(viewController, view: view, isHidden: isHidden)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Method
    
    private func configureUI() {
        backgroundColor = R.Color.white
    }
    
    private func setLayout() {
        addSubviews(backButton, titleLabel, closeButton)
                
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
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.navigationButtonTrailing)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
    }
}
