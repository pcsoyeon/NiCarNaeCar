//
//  SettingViewModel.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/15.
//

import Foundation

final class SettingViewModel {
    var list: Observable<[SettingList]> = Observable([SettingList(title: "",
                                                                  subTitle: nil,
                                                                  detail: nil)])
    
    func setSettingList() {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=" + bundleID),
              let data = try? Data(contentsOf: url),
              let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
              let results = jsonData["results"] as? [[String: Any]],
              results.count > 0,
              let appStoreVersion = results[0]["version"] as? String else { return }
        
        let versionDescription = currentVersion == appStoreVersion ? "최신버전입니다" : "업데이트가 필요합니다"
        
        
        list.value = [SettingList(title: "서비스 이용 약관", subTitle: nil, detail: nil),
                      SettingList(title: "문의하기", subTitle: nil, detail: nil),
                      SettingList(title: "리뷰남기기", subTitle: nil, detail: nil),
                      SettingList(title: "개발자 정보", subTitle: nil, detail: nil),
                      SettingList(title: "오픈소스 라이선스 보기", subTitle: nil, detail: nil),
                      SettingList(title: "앱 버전", subTitle: "\(currentVersion)", detail: versionDescription)]
    }
}
