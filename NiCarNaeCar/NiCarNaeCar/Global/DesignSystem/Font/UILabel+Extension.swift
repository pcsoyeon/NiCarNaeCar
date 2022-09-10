//
//  UILabel+Extension.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/10.
//

import UIKit

extension UILabel {
    func addLabelSpacing(fontStyle: NiCarNaeCarFont) {
        guard let lineHeight = fontStyle.fontProperty.lineHeight else { return }
        let kernValue = fontStyle.fontProperty.kern
        
        if let labelText = text, labelText.count > 0 {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight
            attributedText = NSAttributedString(
                string: labelText,
                attributes: [
                    .kern: kernValue,
                    .paragraphStyle: paragraphStyle
                ]
            )
        }
    }
}
