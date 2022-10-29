//
//  SearchViewModel.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/29.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchViewModel {
    var isFiltering: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var location = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]
    var filteredLocation: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    var numberOfRowsInSection: Int {
        return filteredLocation.value.count
    }
    
    func cellForRowAt(at indexPath: IndexPath) -> String {
        return filteredLocation.value[indexPath.row]
    }
    
    func filterLocation(_ text: String) {
        let filtered = location.filter { $0.contains(text) }
        filteredLocation.accept(filtered)
    }
}
