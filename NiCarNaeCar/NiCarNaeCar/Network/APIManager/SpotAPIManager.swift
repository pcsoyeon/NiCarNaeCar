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
    
    typealias completionHandler = (SpotList) -> Void
    
    static func requestSpotWithPositionId(startPage: Int, endPage: Int, positionId: Int ,completionHandler: @escaping completionHandler) {
        let urlString = EndPoint.spotList.requestURL + "/\(startPage)/\(endPage)/\(positionId)"
        
        guard let url = URL(string: urlString) else {
            print("Wrong URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard error == nil else {
                print("Failed Request")
                return
            }
            
            guard let data = data else {
                print("No Data Returned")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Unable Response")
                return
            }
            
            guard response.statusCode == 200 else {
                print("Failed Response")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(SpotList.self, from: data)
                completionHandler(result)
                
            } catch let error {
                print("============================== 🔴 Decode Error 🔴 ==============================")
                print(error)
            }
        }.resume()
        
    }
}
