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

// MARK: - Section

enum ParkingDetailSection: Int, CustomStringConvertible, CaseIterable {
    case location
    case fee
    case free
    case operatingTime
    case contact
    
    static let count: Int = ParkingDetailSection.allCases.count
    
    var description: String {
        switch self {
        case .location:
            return ""
        case .fee:
            return "요금"
        case .free:
            return "무/유료"
        case .operatingTime:
            return "운영시간"
        case .contact:
            return "전화번호"
        }
    }
    
    var cellForItemTitleList: [String]? {
        switch self {
        case .location:
            return nil
        case .fee:
            return ["기본", "추가"]
        case .free, .operatingTime:
            return ["평일", "토요일", "공휴일"]
        case .contact:
            return ["주차장"]
        }
    }
    
    var numberOfItemsInSection: Int {
        switch self {
        case .location, .contact:
            return 1
        case .fee:
            return 2
        case .free, .operatingTime:
            return 3
        }
    }
}

// MARK: - ParkingDetailViewModel

final class ParkingDetailViewModel {
    
    // MARK: - Property
    
    var location: Observable<ParkingLotLocation> = Observable(ParkingLotLocation())
    var fee: Observable<Fee> = Observable(Fee())
    var free: Observable<Free> = Observable(Free())
    var operatingTime: Observable<OperatingTime> = Observable(OperatingTime())
    var contact: Observable<Contact> = Observable(Contact())
    
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: - Data Method
    
    func fetchParkingDetailInfo(_ item: ParkingDetailInfo) {
        location.value.name = item.parkingName
        location.value.address = item.addr
        
        fee.value.defaultFee = "\(item.rates)원/\(item.timeRate)분"
        fee.value.additionalFee = "\(item.addRates)원/\(item.addTimeRate)분"
        
        free.value.isWeekdayFree = item.payNm
        free.value.isSaturdayFree = item.saturdayPayNm
        free.value.isHolidayFree = item.holidayPayNm
        
        operatingTime.value.weekdayOperatingTime = "\(item.weekdayBeginTime) ~ \(item.weekdayEndTime)"
        operatingTime.value.saturdayOperatingTime = "\(item.weekdayBeginTime) ~ \(item.weekdayEndTime)"
        operatingTime.value.holidayOperatingTime = "\(item.holidayBeginTime) ~ \(item.holidayEndTime)"
        
        contact.value.tel = item.tel
    }
    
    // MARK: - UICollectionView Method
    
    var numberOfSections: Int {
        return 5
    }
    
    func numberOfItemsInSection(at section: Int) -> Int {
        if section == 0 {
            return ParkingDetailSection.location.numberOfItemsInSection
        } else if section == 1 {
            return ParkingDetailSection.fee.numberOfItemsInSection
        } else if section == 2 {
            return ParkingDetailSection.free.numberOfItemsInSection
        } else if section == 3 {
            return ParkingDetailSection.operatingTime.numberOfItemsInSection
        } else {
            return ParkingDetailSection.contact.numberOfItemsInSection
        }
    }
    
    func sizeForItemAt(at section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screenWidth, height: 109)
        } else {
            return CGSize(width: screenWidth, height: 60)
        }
    }
    
    func referenceSizeForHeaderInSection(at section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: screenWidth, height: 0)
        } else {
            return CGSize(width: screenWidth, height: 60)
        }
    }
    
    func titleForSection(_ section: Int, _ headerView: ParkingDetailHeaderView) {
        switch section {
        case 1:
            headerView.title = ParkingDetailSection.fee.description
        case 2:
            headerView.title = ParkingDetailSection.free.description
        case 3:
            headerView.title = ParkingDetailSection.operatingTime.description
        case 4:
            headerView.title = ParkingDetailSection.contact.description
        default:
            headerView.title = ""
        }
    }
    
    func cellForItemAt(_ section: Int) -> ([String]?, [String]) {
        switch section {
        case 0:
            return (nil, [location.value.name, location.value.address])
        case 1:
            return (ParkingDetailSection.fee.cellForItemTitleList, [fee.value.defaultFee, fee.value.additionalFee])
        case 2:
            return (ParkingDetailSection.free.cellForItemTitleList, [free.value.isWeekdayFree, free.value.isSaturdayFree, free.value
                .isHolidayFree])
        case 3:
            return (ParkingDetailSection.operatingTime.cellForItemTitleList, [operatingTime.value.weekdayOperatingTime, operatingTime.value.saturdayOperatingTime, operatingTime.value.holidayOperatingTime])
        case 4:
            return (ParkingDetailSection.contact.cellForItemTitleList, [contact.value.tel])
        default:
            return (nil, [""])
        }
    }
}
