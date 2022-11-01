//
//  LocationDetailViewModel.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/11/02.
//

import Foundation

import NiCarNaeCar_Util

import RxCocoa
import RxSwift

final class DetailViewModel {
    var brandType = CObservable<BrandType>(.socar)
    
    var info = CObservable<BrandInfo>(BrandInfo(brandType: .socar, totalCount: "", availableCount: ""))
    
    var positionName = CObservable<String>("")
    var address = CObservable<String>("")
    
    func openURL() -> String {
        if brandType.value == .socar {
            return "socar:"
        } else {
            return "greencar://"
        }
    }
    
    func numberOfItemsInSection(at section: Int) -> Int {
        return 3
    }
    
    func cellForItemAt(at indexPath: IndexPath) -> (BrandType, String, String?, String?) {
        if indexPath.row == 0 {
            return (brandType.value, positionName.value, address.value, nil)
        } else if indexPath.row == 1 {
            return (brandType.value, "전체 차량 수", nil, info.value.totalCount)
        } else {
            return (brandType.value, "예약 가능 차량 수", nil, info.value.availableCount)
        }
    }
}
