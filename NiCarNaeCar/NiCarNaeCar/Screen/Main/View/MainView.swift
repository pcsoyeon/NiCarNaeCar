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

final class MainView: BaseView {
    
    // MARK: - UI Property
    
    var mapView = MKMapView()
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
        
        addSubviews(mapView)
    }
    
    override func setLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
