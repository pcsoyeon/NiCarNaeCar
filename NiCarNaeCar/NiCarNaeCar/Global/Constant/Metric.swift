//
//  Metric.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/17.
//

import UIKit

// MARK: - Metric Enum

public enum Metric {
    
}

// MARK: - Common

extension Metric {
    static let margin: CGFloat = 25
}

// MARK: - Navigation

extension Metric {
    static let navigationHeight: CGFloat = UIScreen.main.hasNotch ? 44 : 50
    static let navigationTitleTop: CGFloat = 12
    static let navigationTitleLeading: CGFloat = 20
    static let navigationButtonLeading: CGFloat = 4
    static let navigationButtonTrailing: CGFloat = 9
    static let navigationButtonSize: CGFloat = 44
}

// MARK: - TextField

extension Metric {
    static let textFieldHeight = 36
}

// MARK: - FloatingButton

extension Metric {
    static let floatingButtonSize: CGFloat = 47
    static let floatingButtonRadius: CGFloat = 5
}

// MARK: - CTAButton

extension Metric {
    static let ctaButtonLeading: CGFloat = 20
    static let ctaButtonBottom: CGFloat = 25
    static let ctaButtonHeight: CGFloat = 52
}
