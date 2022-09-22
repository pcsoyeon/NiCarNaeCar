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
        $0.isHidden = true
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
    }
    
    private lazy var emptyView = UIView().then {
        $0.addSubviews(emptyLabel)
        $0.backgroundColor = R.Color.white
        $0.isHidden = true
    }
    
    private var emptyLabel = UILabel().then {
        $0.text = """
                  현재 대여할 수 있는 나눔카가 없어요 :(
                  주변의 다른 지점을 찾아볼까요?
                  """
        $0.textColor = R.Color.gray100
        $0.numberOfLines = 0
        $0.font = NiCarNaeCarFont.body3.font
        $0.addLabelSpacing(fontStyle: NiCarNaeCarFont.body3)
        $0.textAlignment = .center
    }
    
    private var searchLocationButton = UIButton().then {
        $0.setTitle("행정구로 찾기", for: .normal)
        $0.setTitleColor(R.Color.gray200, for: .normal)
        $0.setTitleColor(R.Color.gray100, for: .normal)
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
    
    var hasData: Bool = true {
        didSet {
            emptyView.isHidden = hasData ? true : false
            collectionView.isHidden = hasData ? false : true
        }
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        self.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(locationLabel, addressLabel, distanceLabel, lineView, collectionView, emptyView)
        
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
        
        emptyView.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(108)
        }
    }
}
