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
    
    private func checkDeviceNetworkStatus() {
        NetworkConnectionStatus.shared.startMonitoring { isConnected in
            if isConnected {
                print("🟢 네트워크 연결")
                DispatchQueue.main.async {
                    if UserDefaults.standard.bool(forKey: Constant.UserDefaults.isNotFirst) {
                        let viewController = UINavigationController(rootViewController: MainMapViewController())
                        self.transition(viewController, transitionStyle: .presentCrossDissolve)
                    } else {
                        let viewController = UINavigationController(rootViewController: OnboardingViewController())
                        self.transition(viewController, transitionStyle: .presentCrossDissolve)
                    }
                }
                
            } else {
                print("🟠 네트워크 연결 해제!")
                DispatchQueue.main.async {
                    self.presentAlert()
                }
            }
        }
    }
    
    private func setAnimation() {
        showLabel(firstLabel) {
            self.showLabel(self.secondLabel) {
                self.showLabel(self.thirdLabel) {
                    self.showLabel(self.fourthLabel) {
                        
                        self.checkDeviceNetworkStatus()
                        
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
    
    private func presentAlert() {
        let alertController = UIAlertController(
            title: "네트워크에 접속할 수 없습니다.",
            message: "네트워크 연결 상태를 확인해주세요.",
            preferredStyle: .alert
        )
        
        let endAction = UIAlertAction(title: "종료", style: .destructive) { _ in
            // 앱 종료
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                exit(0)
            }
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            // 설정앱 켜주기
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
        alertController.addAction(endAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
