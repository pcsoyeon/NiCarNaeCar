//
//  EndPoint.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import Foundation

extension URL {
    static let baseURL = URLConstant.BaseURL
    
    static func makeEndPointString(_ endPoint: String) -> String {
        return baseURL + endPoint
    }
}

enum EndPoint {
    case spotList
    case carListSO(spot: Int)
    case carListGR(spot: Int)
    
    var requestURL: String {
        switch self {
        case .spotList:
            return URL.makeEndPointString("/\(APIKey.APIKey)/json/NanumcarSpotList")
        case .carListSO(let spot):
            return URL.makeEndPointString("/xml/NanumcarCarList/1/1870/\(spot)/so")
        case .carListGR(let spot):
            return URL.makeEndPointString("/xml/NanumcarCarList/1/1870/\(spot)/gr")
        }
    }
}

