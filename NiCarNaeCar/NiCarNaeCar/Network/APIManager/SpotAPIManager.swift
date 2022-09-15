//
//  SpotAPIManager.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/12.
//

import Foundation

final class SpotAPIManager {
    
    static let shared = SpotAPIManager()
    
    private init() { }
    
    static func requestSpotWithPositionId(startPage: Int, endPage: Int, positionId: Int ,completionHandler: @escaping (SpotList?, APIError?) -> Void) {
        let urlString = EndPoint.spotList.requestURL + "/\(startPage)/\(endPage)/\(positionId)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.request(endpoint: URLRequest(url: url), completionHandler: completionHandler)
    }
}
