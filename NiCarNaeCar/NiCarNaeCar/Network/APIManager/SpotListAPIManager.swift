//
//  LocationAPIManager.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import Foundation

final class SpotListAPIManager {
    
    static let shared = SpotListAPIManager()
    
    private init() { }
    
    static func requestSpotList(startPage: Int, endPage: Int, completionHandler: @escaping (SpotList?, APIError?) -> Void) {
        let urlString = EndPoint.spotList.requestURL + "/\(startPage)/\(endPage)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.request(endpoint: URLRequest(url: url), completionHandler: completionHandler)
    }
}
