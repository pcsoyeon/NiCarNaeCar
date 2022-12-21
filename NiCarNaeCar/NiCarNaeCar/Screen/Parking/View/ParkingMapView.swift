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

final class ParkingMapView: BaseView {
    
    // MARK: - UI Property
    
    var mapView = MKMapView()
    
    lazy var currentLocationButton = NDSFloatingButton().then {
        $0.image = R.Image.btnLocation
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
        configureButton()
    }
    
    override func setLayout() {
        addSubviews(mapView)
        mapView.addSubviews(currentLocationButton)
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Metric.navigationHeight)
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
}

