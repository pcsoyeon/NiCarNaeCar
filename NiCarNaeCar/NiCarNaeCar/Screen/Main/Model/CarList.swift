//
//  CarList.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import Foundation

/*
 <NanumcarCarList>
     <list_total_count>1</list_total_count>
     <RESULT>
         <CODE>INFO-000</CODE>
         <MESSAGE>정상 처리되었습니다.</MESSAGE>
     </RESULT>
     <row>
         <reservAbleAllCnt>0</reservAbleAllCnt>
         <reservAbleCnt>0</reservAbleCnt>
         <SPONAM>하이마트 미아사거리점</SPONAM>
     </row>
 </NanumcarCarList>
 */

struct NanumcarCarList {
    let listTotalCount: Int
    let result: Result
    let row: [CarRow]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case row
    }
}

struct CarRow {
    let reservableAllCount, reservableCount, spotName: String

    enum CodingKeys: String, CodingKey {
        case reservableAllCount = "reservAbleAllCnt"
        case reservableCount = "reservAbleCnt"
        case spotName = "SPONAM"
    }
}
