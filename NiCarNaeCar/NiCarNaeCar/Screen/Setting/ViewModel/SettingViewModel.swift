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
        
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              // CFBundleIdentifier - 앱의 bundle ID.
              let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=" + bundleID),
              let data = try? Data(contentsOf: url),
              let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
              let results = jsonData["results"] as? [[String: Any]],
              results.count > 0,
              let appStoreVersion = results[0]["version"] as? String else { return }
        
        let versionDescription = currentVersion == appStoreVersion ? "최신버전입니다" : "업데이트가 필요합니다"
        
        
        list.value = [Setting(title: "서비스 이용 약관", subTitle: nil, description: nil),
                      Setting(title: "문의하기", subTitle: nil, description: nil),
                      Setting(title: "리뷰남기기", subTitle: nil, description: nil),
                      Setting(title: "개발자 정보", subTitle: nil, description: nil),
                      Setting(title: "오픈소스 라이선스 보기", subTitle: nil, description: nil),
                      Setting(title: "앱 버전", subTitle: "\(currentVersion)", description: versionDescription)]
    }
    
    var numberOfRowsInsection: Int {
        return list.value.count
    }

    func cellForRowAt(at indexPath: IndexPath) -> Setting {
        return list.value[indexPath.row]
    }
    
    func heightForRowAt(at indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func heightForHeaderInSection(at section: Int) -> CGFloat {
        if section == 0 {
            return 88
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func heightForFooterInSection(at section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}
