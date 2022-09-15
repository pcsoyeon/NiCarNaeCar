//
//  SettingViewModel.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/15.
//

import Foundation

final class SettingViewModel {
    var list: Observable<[Setting]> = Observable([Setting(title: "",
                                                               subTitle: nil,
                                                               description: nil)])
    
    func fetchSetting() {
        guard let name = UserDefaults.standard.string(forKey: Constant.UserDefaults.userName) else { return }
        
        list.value = [Setting(title: name, subTitle: "내 정보 수정하기", description: nil),
                      Setting(title: "서비스 이용 약관", subTitle: nil, description: nil),
                      Setting(title: "문의하기", subTitle: nil, description: nil),
                      Setting(title: "개발자 정보", subTitle: nil, description: nil),
                      Setting(title: "오픈소스 라이선스 보기", subTitle: nil, description: nil),
                      Setting(title: "앱 버전", subTitle: "최신버전입니다", description: "1.0.0")]
    }
    
    var numberOfRowsInsection: Int {
        return list.value.count
    }

    func cellForRowAt(at indexPath: IndexPath) -> Setting {
        return list.value[indexPath.row]
    }
}
