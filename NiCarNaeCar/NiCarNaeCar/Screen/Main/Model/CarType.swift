//
//  CarType.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/10.
//

import UIKit

import NiCarNaeCar_Resource

enum CarType {
    case socar
    case greencar
    
    var title: String {
        switch self {
        case .socar:
            return "SOCAR"
        case .greencar:
            return "GREENCAR"
        }
    }
    
    var color: UIColor {
        switch self {
        case .socar:
            return R.Color.blue100
        case .greencar:
            return R.Color.green100
        }
    }
    
    var logoImage: UIImage {
        switch self {
        case .socar:
            return R.Image.imgSocarLogo
        case .greencar:
            return R.Image.imgGreencarLogo
        }
    }
}
