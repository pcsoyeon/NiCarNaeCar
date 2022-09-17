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
    func touchUpSearchBarButton()
    func touchUpRefreshButton()
    func touchUpAddButton()
    func touchUpCurrentLocationButton()
    
}

final class MainView: BaseView {
    
    // MARK: - UI Property
    
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
    
    private lazy var refreshButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.backgroundColor = R.Color.white
        $0.layer.cornerRadius = 22
        $0.makeShadow(R.Color.black100, 0.25, CGSize(width: 0, height: 4), 10)
        $0.addTarget(self, action: #selector(touchUpRefreshButton), for: .touchUpInside)
    }
    
    private lazy var addButton = UIButton().then {
        $0.backgroundColor = R.Color.white
        $0.setTitle("+30", for: .normal)
        $0.setTitleColor(R.Color.black200, for: .normal)
        $0.setTitleColor(R.Color.gray200, for: .highlighted)
        $0.titleLabel?.font = NiCarNaeCarFont.body3.font
        $0.layer.cornerRadius = 22
        $0.makeShadow(R.Color.gray100, 0.25, CGSize(width: 0, height: 4), 10)
        $0.addTarget(self, action: #selector(touchUpAddButton), for: .touchUpInside)
    }
    
    private lazy var currentLocationButton = UIButton().then {
        $0.setTitle("", for: .normal)
        $0.setImage(R.Image.btnLocation, for: .normal)
        $0.backgroundColor = R.Color.white
        $0.layer.cornerRadius = 22
        $0.makeShadow(R.Color.black100, 0.25, CGSize(width: 0, height: 4), 10)
        $0.addTarget(self, action: #selector(touchUpCurrentLocationButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    weak var buttonDelegate: MainViewDelegate?
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
        
        addSubview(mapView)
        mapView.addSubviews(searchBarButton, currentLocationButton, addButton, refreshButton)
    }
    
    override func setLayout() {
        mapView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(57)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        searchBarButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.leading.trailing.equalToSuperview().inset(32)
            make.height.equalTo(47)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.trailing.equalToSuperview().inset(25)
            make.width.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(currentLocationButton.snp.top).offset(-12)
            make.trailing.equalToSuperview().inset(25)
            make.width.height.equalTo(44)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.bottom.equalTo(addButton.snp.top).offset(-12)
            make.trailing.equalToSuperview().inset(25)
            make.width.height.equalTo(44)
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
}
