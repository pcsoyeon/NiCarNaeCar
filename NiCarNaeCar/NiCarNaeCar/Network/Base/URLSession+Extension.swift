//
//  URLSession+Extension.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import Foundation

extension URLSession {
    
    typealias completionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func customDataTask(_ endpoint: URLRequest, completionHandler: @escaping completionHandler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: completionHandler)
        task.resume()
        
        return task
    }
    
    static func request<T: Codable>(_ session: URLSession = .shared, endpoint: URLRequest,  completionHandler: @escaping (T?, APIError?) -> ()) {
        session.customDataTask(endpoint) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    print("Failed Request")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No Data Returned")
                    completionHandler(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    print("Unable Response")
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("Failed Response")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completionHandler(result, nil)
                    
                } catch let error {
                    completionHandler(nil, .invalidData)
                    print(error)
                }
            }
        }
    }
}
