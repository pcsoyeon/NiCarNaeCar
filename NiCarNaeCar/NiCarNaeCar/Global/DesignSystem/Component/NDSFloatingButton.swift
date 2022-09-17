//
//  NDSCircleButton.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/17.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class NDSFloatingButton: UIButton {
    
    // MARK: - Property
    
    var text: String? = nil {
        didSet {
            setTitle(text, for: .normal)
            titleLabel?.addLabelSpacing(fontStyle: NiCarNaeCarFont.body5)
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            setImage(image, for: .normal)
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setLayout()
        makeRound(radius: Metric.circleButtonRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Init UI
    
    private func configureUI() {
        backgroundColor = R.Color.white
        configureTitle()
    }
    
    private func configureTitle() {
        setTitleColor(R.Color.black200, for: .normal)
        setTitleColor(R.Color.gray200, for: .highlighted)
        titleLabel?.font = NiCarNaeCarFont.body5.font
    }
    
    private func setLayout() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(Metric.circleButtonSize)
        }
    }
}
