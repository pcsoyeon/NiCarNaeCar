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
            return 2
        }
    }
    
    func cellForItemAt<T>(at indexPath: IndexPath) -> T {
        if indexPath.section == 0 {
            return info.value.location as! T
        } else if indexPath.section == 1 {
            return info.value.fee as! T
        } else if indexPath.section == 2 {
            return info.value.free as! T
        } else if indexPath.section == 3 {
            return info.value.operatingTime as! T
        } else {
            return info.value.contact.contact as! T
        }
    }
    
    func heightForRowAt(at indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func heightForHeaderInSection(at section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return 60
        }
    }
}
