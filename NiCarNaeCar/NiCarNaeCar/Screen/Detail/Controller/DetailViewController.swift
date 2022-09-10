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
    
    var brandType: BrandType = .socar {
        didSet {
            rootView.openButton.backgroundColor = brandType.color
        }
    }
    
    var info: BrandInfo? {
        didSet {
            
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
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureButton()
    }
    
    override func setLayout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureButton() {
        rootView.delegate = self
    }
}

// MARK: - Custom Delegate

extension DetailViewController: DetailViewDelegate {
    func touchUpOpenButton() {
        var url = ""
        
        if brandType == .socar {
            url = "socar:"
        } else {
            url = "greencar:"
        }
        
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            }
        } else {
            presentAlert(title: "\(brandType.brandNameKR)앱을 설치해주세요")
            print("링크 주소 : \(url)")
        }
    }
    
}
