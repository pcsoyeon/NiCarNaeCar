//
//  ParkingList.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/11.
//

import Foundation

// MARK: - ParkingList

struct ParkingList: Codable {
    let getParkInfo: ParkingListInfo

    enum CodingKeys: String, CodingKey {
        case getParkInfo = "GetParkInfo"
    }
}

// MARK: - GetParkInfo

struct ParkingListInfo: Codable {
    let listTotalCount: Int
    let result: Result
    let row: [ParkingDetailInfo]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}

// MARK: - ParkingDetailInfo

struct ParkingDetailInfo: Codable {
    let parkingName, addr, parkingCode: String
    let parkingType: String
    let parkingTypeNm: String
    let operationRule: String
    let operationRuleNm: String
    let tel: String
    let capacity: Int
    let payYn: String
    let payNm: String
    let nightFreeOpen: String
    let nightFreeOpenNm: String
    let weekdayBeginTime, weekdayEndTime, weekendBeginTime, weekendEndTime: String
    let holidayBeginTime, holidayEndTime, syncTime: String
    let saturdayPayYn: String
    let saturdayPayNm: String
    let holidayPayYn: String
    let holidayPayNm: String
    let fulltimeMonthly, grpParknm: String
    let rates, timeRate, addRates, addTimeRate: Int
    let busRates, busTimeRate, busAddTimeRate, busAddRates: Int
    let dayMaximum: Int
    let lat, lng: Double

    enum CodingKeys: String, CodingKey {
        case parkingName = "PARKING_NAME"
        case addr = "ADDR"
        case parkingCode = "PARKING_CODE"
        case parkingType = "PARKING_TYPE"
        case parkingTypeNm = "PARKING_TYPE_NM"
        case operationRule = "OPERATION_RULE"
        case operationRuleNm = "OPERATION_RULE_NM"
        case tel = "TEL"
        case capacity = "CAPACITY"
        case payYn = "PAY_YN"
        case payNm = "PAY_NM"
        case nightFreeOpen = "NIGHT_FREE_OPEN"
        case nightFreeOpenNm = "NIGHT_FREE_OPEN_NM"
        case weekdayBeginTime = "WEEKDAY_BEGIN_TIME"
        case weekdayEndTime = "WEEKDAY_END_TIME"
        case weekendBeginTime = "WEEKEND_BEGIN_TIME"
        case weekendEndTime = "WEEKEND_END_TIME"
        case holidayBeginTime = "HOLIDAY_BEGIN_TIME"
        case holidayEndTime = "HOLIDAY_END_TIME"
        case syncTime = "SYNC_TIME"
        case saturdayPayYn = "SATURDAY_PAY_YN"
        case saturdayPayNm = "SATURDAY_PAY_NM"
        case holidayPayYn = "HOLIDAY_PAY_YN"
        case holidayPayNm = "HOLIDAY_PAY_NM"
        case fulltimeMonthly = "FULLTIME_MONTHLY"
        case grpParknm = "GRP_PARKNM"
        case rates = "RATES"
        case timeRate = "TIME_RATE"
        case addRates = "ADD_RATES"
        case addTimeRate = "ADD_TIME_RATE"
        case busRates = "BUS_RATES"
        case busTimeRate = "BUS_TIME_RATE"
        case busAddTimeRate = "BUS_ADD_TIME_RATE"
        case busAddRates = "BUS_ADD_RATES"
        case dayMaximum = "DAY_MAXIMUM"
        case lat = "LAT"
        case lng = "LNG"
    }
}
