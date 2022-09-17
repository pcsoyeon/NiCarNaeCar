//
//  Metric.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/17.
//

import UIKit

// MARK: - Metric Enum

public enum Metric {
    static let navigationHeight: CGFloat = UIScreen.main.hasNotch ? 44 : 50
    static let navigationTitleTop: CGFloat = 12
    static let buttonLeading: CGFloat = 4
    static let buttonTrailing: CGFloat = 9
    static let buttonSize: CGFloat = 44
}

extension Metric {
    static let textFieldHeight = 36
}

extension Metric {
    static let circleButtonSize: CGFloat = 50
    static let circleButtonRadius: CGFloat = 25
}

extension Metric {
    static let ctaButtonLeading: CGFloat = 20
    static let ctaButtonBottom: CGFloat = 25
    static let ctaButtonHeight: CGFloat = 52
}
