//
//  ViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit

import NiCarNaeCar_Resource
import NiCarNaeCar_Util

import SnapKit
import Then

final class ViewController: BaseViewController {

    private lazy var button = UIButton().then {
        $0.setTitle("메인으로 이동", for: .normal)
        $0.setTitleColor(R.Color.black200, for: .normal)
        $0.addTarget(self, action: #selector(touchUpButton), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        view.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        view.addSubviews(button)
        button.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    @objc func touchUpButton() {
        transition(MainViewController(), transitionStyle: .presentFullScreen)
    }

}

