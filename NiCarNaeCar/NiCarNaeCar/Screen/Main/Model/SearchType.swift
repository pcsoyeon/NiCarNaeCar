//
//  SearchType.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/19.
//

import Foundation

enum SearchType {
    case locality
    case subLocality
    
    var index: Int {
        switch self {
        case .locality:
            return 1
        case .subLocality:
            return 2
        }
    }
}
