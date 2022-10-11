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
    let parkingType: ParkingType
    let parkingTypeNm: ParkingTypeNm
    let operationRule: String
    let operationRuleNm: OperationRuleNm
    let tel: String
    let capacity: Int
    let payYn: HolidayPayYn
    let payNm: PayNm
    let nightFreeOpen: HolidayPayYn
    let nightFreeOpenNm: NightFreeOpenNm
    let weekdayBeginTime, weekdayEndTime, weekendBeginTime, weekendEndTime: String
    let holidayBeginTime, holidayEndTime, syncTime: String
    let saturdayPayYn: HolidayPayYn
    let saturdayPayNm: PayNm
    let holidayPayYn: HolidayPayYn
    let holidayPayNm: PayNm
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

enum PayNm: String, Codable {
    case 무료 = "무료"
    case 유료 = "유료"
}

enum HolidayPayYn: String, Codable {
    case n = "N"
    case y = "Y"
}

enum NightFreeOpenNm: String, Codable {
    case 야간미개방 = "야간 미개방"
}

enum OperationRuleNm: String, Codable {
    case 버스전용주차장 = "버스전용 주차장"
    case 시간제거주자주차장 = "시간제 + 거주자 주차장"
    case 시간제주차장 = "시간제 주차장"
    case 이륜차전용주차장 = "이륜차 전용 주차장"
}

enum ParkingType: String, Codable {
    case ns = "NS"
    case nw = "NW"
}

enum ParkingTypeNm: String, Codable {
    case 노상주차장 = "노상 주차장"
    case 노외주차장 = "노외 주차장"
}
