//
//  MainView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit
import MapKit

import NiCarNaeCar_Resource
import NiCarNaeCar_Util

import SnapKit
import Then

protocol MainViewDelegate: MainViewController {
    func touchUpSettingButton()
    
    func touchUpSearchBarButton()
    func touchUpRefreshButton()
    func touchUpCurrentLocationButton()
    
}

final class MainView: BaseView {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = R.Color.white
        $0.addSubviews(logoView, settingButton)
    }
    
    private let logoView = UIImageView().then {
        $0.image = R.Image.imgLogo
        $0.backgroundColor = R.Color.white
        $0.contentMode = .scaleToFill
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(R.Image.btnSetting, for: .normal)
        $0.setTitle("", for: .normal)
        $0.addTarget(self, action: #selector(touchUpSettingButton), for: .touchUpInside)
    }
    
    var mapView = MKMapView()
    
    private lazy var searchBarButton = UIButton().then {
        $0.setTitle("행정구/자치구 검색", for: .normal)
        $0.backgroundColor = R.Color.white
        $0.setTitleColor(R.Color.gray200, for: .normal)
        $0.titleLabel?.font = NiCarNaeCarFont.body3.font
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(touchUpSearchBarButton), for: .touchUpInside)
    }
    
    private lazy var refreshButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = R.Color.white
        $0.setImage(R.Image.btnRefresh, for: .normal)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(touchUpRefreshButton), for: .touchUpInside)
    }
    
    private lazy var currentLocationButton = NDSFloatingButton().then {
        $0.image = R.Image.btnLocation
        $0.addTarget(self, action: #selector(touchUpCurrentLocationButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var buttonDelegate: MainViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
        configureButton()
    }
    
    override func setLayout() {
        addSubviews(navigationBar, mapView)
        mapView.addSubviews(searchBarButton, currentLocationButton, refreshButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(57)
        }
        
        logoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(72)
            make.height.equalTo(27)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.navigationButtonTrailing)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalToSuperview().inset(Metric.margin)
            make.width.height.equalTo(47)
        }
        
        searchBarButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.equalTo(refreshButton.snp.trailing).offset(19)
            make.trailing.equalToSuperview().inset(Metric.margin)
            make.height.equalTo(47)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
    
    private func configureButton() {
        [refreshButton, searchBarButton, currentLocationButton].forEach { button in
            button.layer.applySketchShadow(color: R.Color.gray100, alpha: 0.3, x: 0, y: 4, blur: 10, spread: 0)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpSearchBarButton() {
        buttonDelegate?.touchUpSearchBarButton()
    }
    
    @objc func touchUpRefreshButton() {
        buttonDelegate?.touchUpRefreshButton()
    }
    
    @objc func touchUpCurrentLocationButton() {
        buttonDelegate?.touchUpCurrentLocationButton()
    }
    
    @objc func touchUpSettingButton() {
        buttonDelegate?.touchUpSettingButton()
    }
}
