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
        $0.layer.cornerRadius = 21
        $0.makeShadow(R.Color.black100, 0.25, CGSize(width: 0, height: 4), 10)
    }
    
    lazy var searchButton = UIButton().then {
        $0.backgroundColor = R.Color.white
        $0.setTitle("30개 더 찾기", for: .normal)
        $0.setTitleColor(R.Color.black200, for: .normal)
        $0.setTitleColor(R.Color.gray200, for: .highlighted)
        $0.titleLabel?.font = NiCarNaeCarFont.body3.font
        $0.layer.cornerRadius = 25
        $0.makeShadow(R.Color.gray100, 0.25, CGSize(width: 0, height: 4), 10)
    }
    
    var countLabel = UILabel().then {
        $0.text = ""
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body6.font
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
        
        addSubviews(mapView, currentLocationButton, searchButton, countLabel)
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
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(86)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(102)
            make.height.equalTo(43)
        }
        
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
}
