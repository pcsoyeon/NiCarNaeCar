//
//  DetailViewModel.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/19.
//

import Foundation

final class DetailViewModel {
    var info: Observable<BrandInfo> = Observable(BrandInfo(brandType: .socar, totalCount: "0", availableCount: ""))
    
    var positionName: Observable<String> = Observable("")
    var address: Observable<String> = Observable("")
}
