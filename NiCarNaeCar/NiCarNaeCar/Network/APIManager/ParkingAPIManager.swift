//
//  ParkingAPIManager.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/11.
//

import Foundation

final class ParkingAPIManager {
    
    static let shared = ParkingAPIManager()
    
    private init() { }
    
    static func requestParkingList(startPage: Int, endPage: Int, region: String, completionHandler: @escaping (ParkingList?, APIError?) -> Void) {
        let urlString = EndPoint.parkingList.requestURL + "/\(startPage)/\(endPage)/\(region)"
        
        if let safeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: safeString) {
            URLSession.request(endpoint: URLRequest(url: url), completionHandler: completionHandler)
        }
    }
}
