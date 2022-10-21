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

// MARK: - ParkingDetailViewModel

final class ParkingDetailViewModel {
    
    // MARK: - Property
    
    var parkingLot: Observable<ParkingLot> = Observable(ParkingLot())
    
    // MARK: - Data Method
    
    func fetchParkingDetailInfo(_ item: ParkingDetailInfo) {
        parkingLot.value.name = item.parkingName
        parkingLot.value.location = item.addr
        
        parkingLot.value.defaultFee = "\(item.rates)원/\(item.timeRate)분"
        parkingLot.value.additionalFee = "\(item.addRates)원/\(item.addTimeRate)분"
        
        parkingLot.value.isWeekdayFree = (item.payNm)
        parkingLot.value.isSaturdayFree = (item.saturdayPayNm)
        parkingLot.value.isHolidayFree = (item.holidayPayNm)
        
        parkingLot.value.weekdayOperatingTime = "\(item.weekdayBeginTime) ~ \(item.weekdayEndTime)"
        parkingLot.value.saturdayOperatingTime = "\(item.weekdayBeginTime) ~ \(item.weekdayEndTime)"
        parkingLot.value.holidayOperatingTime = "\(item.holidayBeginTime) ~ \(item.holidayEndTime)"
        
        parkingLot.value.contact = item.tel
    }
    
}
