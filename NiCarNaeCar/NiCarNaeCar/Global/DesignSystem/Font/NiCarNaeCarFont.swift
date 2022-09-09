//
//  NiCarNaeCarFont.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

public struct FontProperty {
    let font: UIFont.FontType
    let size: CGFloat
    let kern: CGFloat
    let lineHeight: CGFloat?
}

public enum NiCarNaeCarFont {
    case title0
    case title1
    case title2
    case title3
    
    case body1
    case body2
    case body3
    case body4
    case body5
    case body6
    case body7
    
    public var fontProperty: FontProperty {
        switch self {
        case .title0:
            return FontProperty(font: .semibold, size: 90, kern: -0.3, lineHeight: 100)
        case .title1:
            return FontProperty(font: .semibold, size: 24, kern: -0.3, lineHeight: 34)
        case .title2:
            return FontProperty(font: .semibold, size: 20, kern: -0.3, lineHeight: nil)
        case .title3:
            return FontProperty(font: .medium, size: 20, kern: -0.3, lineHeight: 28)
        case .body1:
            return FontProperty(font: .semibold, size: 18, kern: -0.3, lineHeight: nil)
        case .body2:
            return FontProperty(font: .medium, size: 18, kern: -0.3, lineHeight: 34)
        case .body3:
            return FontProperty(font: .regular, size: 18, kern: -0.3, lineHeight: 28)
        case .body4:
            return FontProperty(font: .medium, size: 16, kern: -0.3, lineHeight: nil)
        case .body5:
            return FontProperty(font: .regular, size: 16, kern: -0.3, lineHeight: 20)
        case .body6:
            return FontProperty(font: .medium, size: 14, kern: -0.3, lineHeight: nil)
        case .body7:
            return FontProperty(font: .regular, size: 14, kern: -0.3, lineHeight: nil)
        }
    }
}

public extension NiCarNaeCarFont {
    var font: UIFont {
        guard let font = UIFont(name: fontProperty.font.name, size: fontProperty.size) else {
            return UIFont()
        }
        return font
    }
}
