//
//  LocationAPIManager.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import Foundation

class SpotListAPIManager {
    
    static let shared = SpotListAPIManager()
    
    private init() { }
    
    typealias completionHandler = ((SpotList)) -> Void
    
    static func requestSpotList(startPage: Int, endPage: Int, completionHander: @escaping completionHandler) {
        let urlString = EndPoint.spotList.requestURL + "/\(startPage)/\(endPage)"
        
        guard let url = URL(string: urlString) else { return }
        
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
                print("============================== 🟢 Success 🟢 ==============================")
                completionHander(result)
                
            } catch let error {
                print("============================== 🔴 Decode Error 🔴 ==============================")
                print(error)
            }
            
        }.resume()
    }
}
