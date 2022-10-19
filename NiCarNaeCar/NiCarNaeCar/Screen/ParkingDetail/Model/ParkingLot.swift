//
//  ParkinDetail.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/19.
//

import Foundation

struct ParkingLot {
    var location = ParkingLotLocation()
    var fee = Fee()
    var free = Free()
    var operatingTime = OperatingTime()
    var contact = Contact()
}

struct ParkingLotLocation {
    var name: String = ""
    var address: String = ""
}

struct Fee {
    var defaultFee: String = ""
    var additionalFee: String = ""
}

struct Free {
    var isWeekdayFree: String = ""
    var isSaturdayFree: String = ""
    var isHolidayFree: String = ""
}

struct OperatingTime {
    var weekdayOperatingTime: String = ""
    var saturdayOperatingTime: String = ""
    var holidayOperatingTime: String = ""
}

struct Contact {
    var contact: String = ""
}
