//
//  MainViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit

import NiCarNaeCar_Util

final class MainViewController: BaseViewController {
    
    private let mainView = MainView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func setLayout() {
        
    }
}
