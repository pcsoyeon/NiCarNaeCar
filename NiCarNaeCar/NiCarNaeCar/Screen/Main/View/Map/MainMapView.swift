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
    func touchUpCurrentLocationButton()
}

final class MainMapView: BaseView {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = R.Color.white
        $0.addSubviews(logoView, searchButton)
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
    
    var mapView = MKMapView()
    
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
        mapView.addSubviews(currentLocationButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(Metric.navigationHeight)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Metric.navigationTitleTop)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.navigationTitleLeading)
            make.width.equalTo(72)
            make.height.equalTo(27)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.navigationButtonTrailing)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(35)
            make.trailing.equalToSuperview().inset(Metric.margin)
        }
    }
    
    private func configureButton() {
        currentLocationButton.layer.applySketchShadow(color: R.Color.gray100, alpha: 0.3, x: 0, y: 4, blur: 10, spread: 0)
    }
    
    // MARK: - @objc
    
    @objc func touchUpSearchButton() {
        buttonDelegate?.touchUpSearchButton()
    }
    
    @objc func touchUpCurrentLocationButton() {
        buttonDelegate?.touchUpCurrentLocationButton()
    }
}
