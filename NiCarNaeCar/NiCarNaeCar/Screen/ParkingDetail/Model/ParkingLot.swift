//
//  ParkinDetail.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/19.
//

import Foundation

struct ParkingLot: Hashable {
    var name: String = ""
    var location: String = ""
    
    var defaultFee: String = ""
    var additionalFee: String = ""
    
    var isWeekdayFree: String = ""
    var isSaturdayFree: String = ""
    var isHolidayFree: String = ""
    
    var weekdayOperatingTime: String = ""
    var saturdayOperatingTime: String = ""
    var holidayOperatingTime: String = ""
    
    var contact: String = ""
}
