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
    
    var parkingLot: CObservable<ParkingLot> = CObservable(ParkingLot())
    
    // MARK: - Data Method
    
    func fetchParkingDetailInfo(_ item: ParkingDetailInfo) {
        parkingLot.value.name = item.parkingName
        parkingLot.value.location = item.addr
        
        processFee(item)
        
        parkingLot.value.isWeekdayFree = item.payNm
        parkingLot.value.isSaturdayFree = item.saturdayPayNm
        parkingLot.value.isHolidayFree = item.holidayPayNm
        
        processOperatingTime(item)
        
        parkingLot.value.contact = item.tel
    }
    
    private func processFee(_ item: ParkingDetailInfo) {
        parkingLot.value.defaultFee = "\(item.rates)원/\(item.timeRate)분"
        parkingLot.value.additionalFee = "\(item.addRates)원/\(item.addTimeRate)분"
    }
    
    private func processOperatingTime(_ item: ParkingDetailInfo) {
        parkingLot.value.weekdayOperatingTime = "\(stringFormatter(item.weekdayBeginTime)) ~ \(stringFormatter(item.weekdayEndTime))"
        parkingLot.value.saturdayOperatingTime = "\(stringFormatter(item.weekdayBeginTime)) ~ \(stringFormatter(item.weekdayEndTime))"
        parkingLot.value.holidayOperatingTime = "\(stringFormatter(item.holidayBeginTime)) ~ \(stringFormatter(item.holidayEndTime))"
    }
    
    private func stringFormatter(_ str: String) -> String {
        var time = str
        time.insert(":", at: time.index(time.startIndex, offsetBy: 2))
        return time
    }
}
