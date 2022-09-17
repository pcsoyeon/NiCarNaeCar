//
//  SettingNameController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/17.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class SettingNameController: BaseViewController {
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.viewType = .main
        $0.backButtonIsHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func setLayout() {
        super.setLayout()
        view.addSubviews(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}
