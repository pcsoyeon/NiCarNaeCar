//
//  MainViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit

import NiCarNaeCar_Util

final class MainViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentAlert(title: "ㅎ2")
    }
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = .systemPink
    }
    
    override func setLayout() {
        
    }
}
