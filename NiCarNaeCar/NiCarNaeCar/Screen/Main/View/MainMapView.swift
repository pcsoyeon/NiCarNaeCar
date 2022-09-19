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

protocol MainMapViewDelegate: MainMapViewController {
    func touchUpSettingButton()
    func touchUpSearchButton()
    func touchUpRefreshButton()
    func touchUpCurrentLocationButton()
}

final class MainMapView: BaseView {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = R.Color.white
        $0.addSubviews(logoView, settingButton, searchButton)
    }
    
    private let logoView = UIImageView().then {
        $0.image = R.Image.imgLogo
        $0.backgroundColor = R.Color.white
        $0.contentMode = .scaleToFill
    }
    
    private lazy var searchButton = UIButton().then {
        $0.setImage(R.Image.btnSearch, for: .normal)
        $0.setTitle("", for: .normal)
        $0.addTarget(self, action: #selector(touchUpSearchButton), for: .touchUpInside)
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(R.Image.btnSetting, for: .normal)
        $0.setTitle("", for: .normal)
        $0.addTarget(self, action: #selector(touchUpSettingButton), for: .touchUpInside)
    }
    
    var mapView = MKMapView()
    
    private lazy var refreshButton = NDSFloatingButton().then {
        $0.image = R.Image.btnRefresh
        $0.addTarget(self, action: #selector(touchUpRefreshButton), for: .touchUpInside)
    }
    
    private lazy var currentLocationButton = NDSFloatingButton().then {
        $0.image = R.Image.btnLocation
        $0.addTarget(self, action: #selector(touchUpCurrentLocationButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var buttonDelegate: MainMapViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
        configureButton()
    }
    
    override func setLayout() {
        addSubviews(navigationBar, mapView)
        mapView.addSubviews(currentLocationButton, refreshButton)
        
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
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(settingButton.snp.leading)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(60)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.bottom.equalTo(currentLocationButton.snp.top).offset(-18)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
    
    private func configureButton() {
        [refreshButton, currentLocationButton].forEach { button in
            button.layer.applySketchShadow(color: R.Color.gray100, alpha: 0.3, x: 0, y: 4, blur: 10, spread: 0)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpSearchButton() {
        buttonDelegate?.touchUpSearchButton()
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
