//
//  ParkingMapView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/11.
//


import UIKit
import MapKit

import NiCarNaeCar_Resource
import NiCarNaeCar_Util

import SnapKit
import Then

protocol ParkingMapViewDelegate: ParkingViewController {
    func touchUpCurrentLocationButton()
}

final class ParkingMapView: BaseView {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = UIView().then {
        $0.backgroundColor = R.Color.white
        $0.addSubviews(titleLabel)
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "주차장"
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title2.font
    }
    
    var mapView = MKMapView()
    
    private lazy var currentLocationButton = NDSFloatingButton().then {
        $0.image = R.Image.btnLocation
        $0.addTarget(self, action: #selector(touchUpCurrentLocationButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var buttonDelegate: ParkingMapViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(navigationBar, mapView)
        mapView.addSubviews(currentLocationButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(57)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(25)
            make.width.equalTo(72)
            make.height.equalTo(27)
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
    
    @objc func touchUpCurrentLocationButton() {
        buttonDelegate?.touchUpCurrentLocationButton()
    }
}

