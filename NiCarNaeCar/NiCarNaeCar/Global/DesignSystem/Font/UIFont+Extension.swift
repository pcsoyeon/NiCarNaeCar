//
//  Font+Extension.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

extension UIFont {
    enum FontType: String {
        case extrabold = "Pretendard-ExtraBold"
        case bold = "Pretendard-Bold"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semibold = "Pretendard-Semibold"
        
        var name: String {
            return self.rawValue
        }
        
        static func font(_ type: FontType, ofsize size: CGFloat) -> UIFont {
            return UIFont(name: type.rawValue, size: size)!
        }
    }
}
