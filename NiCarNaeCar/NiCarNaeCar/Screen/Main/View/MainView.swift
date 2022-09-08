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
    
    lazy var currentLocationButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.setImage(R.Image.btnLocation, for: .normal)
        $0.backgroundColor = R.Color.white
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
        
        addSubviews(mapView, currentLocationButton)
    }
    
    override func setLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(67)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.trailing.equalTo(self.safeAreaLayoutGuide).inset(25)
            make.width.height.equalTo(42)
        }
    }
}
