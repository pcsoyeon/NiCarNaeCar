//
//  SplashViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/17.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class SplashViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let firstLabel = UILabel().then {
        $0.text = "니"
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0
    }
    
    private let secondLabel = UILabel().then {
        $0.text = "카"
        $0.textColor = R.Color.green100
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0
    }
    
    private let thirdLabel = UILabel().then {
        $0.text = "내"
        $0.textColor = R.Color.black200
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0
    }
    
    private let fourthLabel = UILabel().then {
        $0.text = "카"
        $0.textColor = R.Color.blue100
        $0.font = NiCarNaeCarFont.title0.font
        $0.alpha = 0
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAnimation()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        view.addSubviews(firstLabel, secondLabel, thirdLabel, fourthLabel)

        firstLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(321)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(32)
        }

        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(303)
            make.leading.equalTo(firstLabel.snp.trailing)
        }

        thirdLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(321)
            make.leading.equalTo(secondLabel.snp.trailing)
        }

        fourthLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(303)
            make.leading.equalTo(thirdLabel.snp.trailing)
        }
    }
    
    // MARK: - Custom Method
    
    private func presentMain() {
        if UserDefaults.standard.bool(forKey: Constant.UserDefaults.isNotFirst) {
            let viewController = UINavigationController(rootViewController: MainMapViewController())
            self.transition(viewController, transitionStyle: .presentCrossDissolve)
        } else {
            let viewController = UINavigationController(rootViewController: OnboardingViewController())
            self.transition(viewController, transitionStyle: .presentCrossDissolve)
        }
    }
    
    private func setAnimation() {
        showLabel(firstLabel) {
            self.showLabel(self.secondLabel) {
                self.showLabel(self.thirdLabel) {
                    self.showLabel(self.fourthLabel) {
                        if self.checkUpdateAvailable() {
                            self.presentUpdateAlert()
                        } else {
                            self.presentMain()
                        }
                    }
                }
            }
        }
    }
    
    private func showLabel(_ component: UILabel, completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut) {
            component.transform = CGAffineTransform(translationX: 0, y: -16)
            component.alpha = 1
        } completion: { _ in
            completion()
        }
    }
    
    private func checkUpdateAvailable() -> Bool {
        // CFBundleShortVersionString - 릴리즈 혹은 bundle 의 버전.
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
              // CFBundleIdentifier - 앱의 bundle ID.
              let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=" + bundleID),
              let data = try? Data(contentsOf: url),
              let jsonData = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
              let results = jsonData["results"] as? [[String: Any]],
              results.count > 0,
              let appStoreVersion = results[0]["version"] as? String else { return false }
        
        let currentVersionArray = currentVersion.split(separator: ".").map { $0 }
        let appStoreVersionArray = appStoreVersion.split(separator: ".").map { $0 }
        
        // ✅ [Major].[Minor].[Patch]
        print("현재 버전: ", currentVersion, "앱 스토어 버전: ", appStoreVersion)
        // ✅ 앞자리(Major)가 낮으면 업데이트
        if currentVersionArray[0] < appStoreVersionArray[0] {
            return true
        } else {
            // ✅ 중간자리(Minor) 역시 낮으면 업데이트
//            return currentVersionArray[1] < appStoreVersionArray[1] ? true : false
            return false
        }
    }
    
    private func presentUpdateAlert() {
        let alertVC = UIAlertController(title: "업데이트", message: "업데이트가 필요합니다.", preferredStyle: .alert)
        let alertAtion = UIAlertAction(title: "업데이트", style: .default) { _ in
            // ✅ App store connet 앱의 일반 정보의 Apple ID 입력.
            let appleID = APIKey.AppId
            // ✅ URL Scheme 방식을 이용해서 앱스토어를 연결.
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/\(appleID)") else { return }
            // ✅ canOpenURL(_:) - 앱이 URL Scheme 처리할 수 있는지 여부를 나타내는 Boolean 값을 리턴한다.
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        alertVC.addAction(alertAtion)
        
        present(alertVC, animated: true)
    }
}
