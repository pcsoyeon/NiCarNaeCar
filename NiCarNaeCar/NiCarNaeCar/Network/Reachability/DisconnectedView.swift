//
//  DisconnectedView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/29.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class DisconnectedView: BaseView {
    
    // MARK: - Property
    
    private let firstLabel = UILabel().then {
        $0.text = "니"
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0.5
    }
    
    private let secondLabel = UILabel().then {
        $0.text = "카"
        $0.textColor = R.Color.green100
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0.5
    }
    
    private let thirdLabel = UILabel().then {
        $0.text = "내"
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0.5
    }
    
    private let fourthLabel = UILabel().then {
        $0.text = "카"
        $0.textColor = R.Color.blue100
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0.5
    }
    
    private var overlayView = UIView().then {
        $0.backgroundColor = UIColor(white: 0, alpha: 0.85)
    }
    
    private var descriptionLabel = UILabel().then {
        $0.text = """
                  네트워크 연결을 확인해주세요.
                  와이파이 또는 셀룰러를 연결해주세요.
                  """
        $0.textColor = .white
        $0.font = NiCarNaeCarFont.body1.font
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubviews(firstLabel, secondLabel, thirdLabel, fourthLabel, overlayView, descriptionLabel)
        
        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(321)
            make.leading.equalTo(self.safeAreaLayoutGuide).inset(32)
        }

        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(303)
            make.leading.equalTo(firstLabel.snp.trailing)
        }

        thirdLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(321)
            make.leading.equalTo(secondLabel.snp.trailing)
        }

        fourthLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(303)
            make.leading.equalTo(thirdLabel.snp.trailing)
        }
        
        overlayView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}
