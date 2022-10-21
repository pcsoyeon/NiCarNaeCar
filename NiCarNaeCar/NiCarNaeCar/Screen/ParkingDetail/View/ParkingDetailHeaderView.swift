//
//  ParkingDetailHeaderView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/19.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class ParkingDetailHeaderView: UICollectionReusableView {
    
    static var reuseIdentifier: String { return String(describing: self) }
    
    // MARK: - Property
    
    
    private let lineView = UIView().then {
        $0.backgroundColor = R.Color.gray400
    }
    
    private var titleLabel = UILabel().then {
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.body1.font
    }
    
    // MARK: - Property
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Initialzier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    // MARK: - Init UI
    
    private func configureUI() {
        backgroundColor = R.Color.white
    }
    
    private func setLayout() {
        addSubviews(lineView, titleLabel)
        
        lineView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(Metric.margin)
        }
    }
}

