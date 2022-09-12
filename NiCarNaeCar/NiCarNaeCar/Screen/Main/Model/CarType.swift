//
//  CarType.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/12.
//

import Foundation

// (TO: 혼합차량 EV: 전기차 GA: 가솔린차)
enum CarType {
    case TO
    case EV
    case GA
    
    var text: String {
        switch self {
        case .TO:
            return "혼합차량"
        case .EV:
            return "전기차"
        case .GA:
            return "가솔린차"
        }
    }
}
