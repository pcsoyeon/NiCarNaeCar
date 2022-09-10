//
//  DetailViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

class DetailViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = DetailView()
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.viewType = .detail
        $0.backButtonIsHidden = true
    }
    
    // MARK: - Property
    
    var carType: BrandType = .socar {
        didSet {
            rootView.nextButton.backgroundColor = carType.color
        }
    }
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setLayout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - UI Method
}
