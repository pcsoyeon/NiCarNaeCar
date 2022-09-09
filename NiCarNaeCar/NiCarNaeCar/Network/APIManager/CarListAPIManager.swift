//
//  CarListAPIManager.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import Foundation

class CarListAPIManger {
    static let shared = CarListAPIManger()
    
    private init() { }
    
    typealias completionHandler = (CarRow) -> Void
    
    enum XMLKey: String {
        case listTotalCount = "list_total_count"
        case reservableAllCount = "reservAbleAllCnt"
        case reservableCount = "reservAbleCnt"
        case spotName = "SPONAM"
    }
    
    static func requestSocarList(startPage: Int, endPage: Int, spot: Int, completionHandler: @escaping completionHandler) {
        let urlString = EndPoint.carListSO.requestURL + "/\(startPage)/\(endPage)/\(spot)/so"
        
        guard let url = URL(string: urlString) else { return }
        
        if let parser = XMLParser(contentsOf: url) {

        }
    }
    
    static func requestGreecarList(startPage: Int, endPage: Int, spot: Int, completionHandler: @escaping completionHandler) {
        let urlString = EndPoint.carListGR.requestURL + "/\(startPage)/\(endPage)/\(spot)/so"
        
        guard let url = URL(string: urlString) else { return }
        
        if let parser = XMLParser(contentsOf: url) {

        }
    }
}
