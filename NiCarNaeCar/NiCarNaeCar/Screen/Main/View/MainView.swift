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
    func touchUpAddButton()
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
        $0.setTitle("행정구를 검색해보세요", for: .normal)
        $0.backgroundColor = R.Color.white
        $0.setTitleColor(R.Color.black200, for: .normal)
        $0.setTitleColor(R.Color.gray200, for: .highlighted)
        $0.titleLabel?.font = NiCarNaeCarFont.body3.font
        $0.layer.cornerRadius = 5
        $0.makeShadow(R.Color.gray100, 0.25, CGSize(width: 0, height: 4), 10)
        $0.addTarget(self, action: #selector(touchUpSearchBarButton), for: .touchUpInside)
    }
    
    private lazy var refreshButton = NDSFloatingButton().then {
        $0.addTarget(self, action: #selector(touchUpRefreshButton), for: .touchUpInside)
    }
    
    private lazy var addButton = NDSFloatingButton().then {
        $0.text = "+30"
        $0.addTarget(self, action: #selector(touchUpAddButton), for: .touchUpInside)
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
    }
    
    override func setLayout() {
        addSubviews(navigationBar, mapView)
        mapView.addSubviews(searchBarButton, currentLocationButton, addButton, refreshButton)
        
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
        
        searchBarButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(47)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(currentLocationButton.snp.top).offset(-15)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.bottom.equalTo(addButton.snp.top).offset(-15)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpSearchBarButton() {
        buttonDelegate?.touchUpSearchBarButton()
    }
    
    @objc func touchUpRefreshButton() {
        buttonDelegate?.touchUpRefreshButton()
    }
    
    @objc func touchUpAddButton() {
        buttonDelegate?.touchUpAddButton()
    }
    
    @objc func touchUpCurrentLocationButton() {
        buttonDelegate?.touchUpCurrentLocationButton()
    }
    
    @objc func touchUpSettingButton() {
        buttonDelegate?.touchUpSearchBarButton()
    }
}
