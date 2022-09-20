//
//  SheetView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit
import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class MainSheetView: BaseView {
    
    // MARK: - UI Property
    
    private var locationLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title3.font
    }
    
    private var addressLabel = UILabel().then {
        $0.textColor = R.Color.gray100
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    private var distanceLabel = UILabel().then {
        $0.textColor = R.Color.gray100
        $0.font = NiCarNaeCarFont.body5.font
    }
    
    private var lineView = UIView().then {
        $0.backgroundColor = R.Color.gray400
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
            $0.backgroundColor = R.Color.white
            $0.contentInsetAdjustmentBehavior = .never
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
        }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    // MARK: - Property
    
    var positionName: String = "" {
        didSet {
            locationLabel.text = positionName
        }
    }
    
    var distance: String = "0" {
        didSet {
            distanceLabel.text = distance
        }
    }
    
    var address: String = "" {
        didSet {
            addressLabel.text = address
        }
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(locationLabel, addressLabel, distanceLabel, lineView, collectionView)
        
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(33)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.margin)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(8)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(Metric.margin)
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(3)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.margin)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(distanceLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.margin)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(46)
        }
    }
}
