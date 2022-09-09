//
//  Location.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import Foundation

// MARK: - Welcome

struct SpotList: Codable {
    let nanumcarSpotList: NanumcarSpotList

    enum CodingKeys: String, CodingKey {
        case nanumcarSpotList = "NanumcarSpotList"
    }
}

// MARK: - NanumcarSpotList

struct NanumcarSpotList: Codable {
    let listTotalCount: Int
    let result: Result
    let row: [Row]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}

// MARK: - Result

struct Result: Codable {
    let code, message: String

    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

// MARK: - Row

struct Row: Codable {
    let la, lo, positnCD: String
    let elctyvhcleAt: String
    let adres, positnNm: String

    enum CodingKeys: String, CodingKey {
        case la = "LA"
        case lo = "LO"
        case positnCD = "POSITN_CD"
        case elctyvhcleAt = "ELCTYVHCLE_AT"
        case adres = "ADRES"
        case positnNm = "POSITN_NM"
    }
}

