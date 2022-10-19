//
//  ParkingDetailViewModel.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/19.
//

import UIKit

import SnapKit
import Then

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class ParkingDetailViewModel {
    var info: Observable<ParkingLot> = Observable(ParkingLot())
    
    func fetchParkingDetailInfo(_ data: ParkingLot) {
        info.value = data
    }
    
    var numberOfSections: Int {
        return 5
    }
    
    func numberOfItemsInSection(at section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
        } else if section == 2 {
            return 3
        } else if section == 3 {
            return 3
        } else {
            return 1
        }
    }
}
