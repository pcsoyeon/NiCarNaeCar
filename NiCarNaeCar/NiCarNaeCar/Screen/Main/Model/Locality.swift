//
//  Locality.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import Foundation
import CoreLocation

// TODO: - REMOVE

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

enum LocalityType: String, CaseIterable {
    case 강남구
    case 강동구
    case 강북구
    case 강서구
    case 관악구
    case 광진구
    case 구로구
    case 금천구
    case 노원구
    case 도봉구
    case 동대문구
    case 동작구
    case 마포구
    case 서대문구
    case 서초구
    case 성동구
    case 성북구
    case 송파구
    case 양천구
    case 영등포구
    case 용산구
    case 은평구
    case 종로구
    case 중구
    case 중랑구
    
    var location: CLLocationCoordinate2D {
        switch self {
        case .강남구:
            return CLLocationCoordinate2D(latitude: 37.498095, longitude: 127.027610)
        case .강동구:
            return CLLocationCoordinate2D(latitude: 37.53246, longitude: 127.1237)
        case .강북구:
            return CLLocationCoordinate2D(latitude: 37.64278, longitude: 127.0253)
        case .강서구:
            return CLLocationCoordinate2D(latitude: 37.55111, longitude: 126.84930)
        case .관악구:
            return CLLocationCoordinate2D(latitude: 37.48467, longitude: 126.9515)
        case .광진구:
            return CLLocationCoordinate2D(latitude: 37.54104, longitude: 127.0826)
        case .구로구:
            return CLLocationCoordinate2D(latitude: 37.50237, longitude: 126.8890)
        case .금천구:
            return CLLocationCoordinate2D(latitude: 37.45644, longitude: 126.89550)
        case .노원구:
            return CLLocationCoordinate2D(latitude: 37.65664, longitude: 127.0559)
        case .도봉구:
            return CLLocationCoordinate2D(latitude: 37.67214, longitude: 127.0462)
        case .동대문구:
            return CLLocationCoordinate2D(latitude: 37.57792, longitude: 127.0401)
        case .동작구:
            return CLLocationCoordinate2D(latitude:  37.51871, longitude: 126.9364)
        case .마포구:
            return CLLocationCoordinate2D(latitude: 37.57003, longitude: 126.9019)
        case .서대문구:
            return CLLocationCoordinate2D(latitude: 37.58567, longitude: 126.9357)
        case .서초구:
            return CLLocationCoordinate2D(latitude: 37.49093, longitude: 127.0329)
        case .성동구:
            return CLLocationCoordinate2D(latitude: 37.54691, longitude: 127.04114)
        case .성북구:
            return CLLocationCoordinate2D(latitude: 37.59342, longitude: 127.0172)
        case .송파구:
            return CLLocationCoordinate2D(latitude: 37.51803, longitude: 127.1056)
        case .양천구:
            return CLLocationCoordinate2D(latitude: 37.52007, longitude: 126.9549)
        case .영등포구:
            return CLLocationCoordinate2D(latitude: 37.54240, longitude: 126.8402)
        case .용산구:
            return CLLocationCoordinate2D(latitude: 37.53804, longitude: 126.9913)
        case .은평구:
            return CLLocationCoordinate2D(latitude: 37.60675, longitude: 126.9302)
        case .종로구:
            return CLLocationCoordinate2D(latitude: 37.57615, longitude: 126.9790)
        case .중구:
            return CLLocationCoordinate2D(latitude: 37.56798, longitude: 126.9975)
        case .중랑구:
            return CLLocationCoordinate2D(latitude: 37.60961, longitude: 127.0931)
        }
    }
}
