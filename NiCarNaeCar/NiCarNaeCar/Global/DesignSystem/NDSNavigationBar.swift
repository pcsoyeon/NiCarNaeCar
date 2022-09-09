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

// MARK: - Metric Enum

public enum Metric {
    static let navigationHeight: CGFloat = UIScreen.main.hasNotch ? 44 : 50
    static let titleTop: CGFloat = 11
    static let buttonLeading: CGFloat = 4
    static let buttonTrailing: CGFloat = 9
    static let buttonSize: CGFloat = 44
}

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
                return "차량 정보"
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
    
    var backButtonIsHidden: Bool = false {
        didSet {
            backButton.isHidden = backButtonIsHidden
            closeButton.isHidden = !backButtonIsHidden
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
            make.leading.equalToSuperview().inset(Metric.buttonLeading)
            make.width.height.equalTo(Metric.buttonSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(9)
            make.centerX.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(Metric.buttonTrailing)
            make.width.height.equalTo(Metric.buttonSize)
        }
    }
    
    // MARK: - Custom Method
    
    private func setBackButton(isHidden: Bool) {
        backButton.isHidden = isHidden
        closeButton.isHidden = !backButton.isHidden
    }
}
