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
    case carListSO
    case carListGR
    
    var requestURL: String {
        switch self {
        case .spotList:
            return URL.makeEndPointString("/\(APIKey.APIKey)/json/NanumcarSpotList")
        case .carListSO:
            return URL.makeEndPointString("/\(APIKey.APIKey)/xml/NanumcarCarList")
        case .carListGR:
            return URL.makeEndPointString("/\(APIKey.APIKey)/xml/NanumcarCarList")
        }
    }
}

