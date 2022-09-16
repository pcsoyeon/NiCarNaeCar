//
//  Locality.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import Foundation

struct Locality {
    static let gangnamList = ["신사동",
                              "논현1동",
                              "논현2동",
                              "삼성1동",
                              "삼성2동",
                              "대치1동",
                              "대치2동",
                              "대치3동",
                              "대치4동",
                              "역삼1동",
                              "역삼2동",
                              "도곡1동",
                              "도곡2동",
                              "압구정1동",
                              "압구정2동",
                              "개포1동",
                              "개포2동",
                              "개포3동",
                              "개포4동",
                              "일원본동",
                              "일원1동",
                              "일원2동",
                              "수서동",
                              "세곡동",
                              "압구정동",
                              "청담동",
                              "청담1동",
                              "청담2동"]
    
    static func searchLocality(_ subLocality: String) -> String {
        if gangnamList.contains(subLocality) {
            return "강남구"
        }
        return ""
    }
}
