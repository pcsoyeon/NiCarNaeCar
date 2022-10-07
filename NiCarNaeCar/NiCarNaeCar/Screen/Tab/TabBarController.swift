//
//  TabBarController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/07.
//

import UIKit

import NiCarNaeCar_Resource

final class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarViewController()
    }

    private func configureTabBarViewController() {
        delegate = self
        
        UITabBar.appearance().backgroundColor = R.Color.white
        tabBar.tintColor = R.Color.black200
        tabBar.barTintColor = R.Color.white
        tabBar.isTranslucent = false
        
        let firstTabController = MainMapViewController()
        let secondTabController = ParkingViewController()
        let thirdTabController = SettingViewController()
        
        firstTabController.tabBarItem = UITabBarItem(
            title: "홈",
            image: R.Image.icHome,
            selectedImage: R.Image.icHome)
                
        secondTabController.tabBarItem = UITabBarItem(
            title: "주차장",
            image: R.Image.icParking,
            selectedImage: R.Image.icParking)
        
        thirdTabController.tabBarItem = UITabBarItem(
            title: "설정",
            image: R.Image.icSetting,
            selectedImage: R.Image.icSetting)
        
        self.viewControllers = [firstTabController, secondTabController, thirdTabController]
    }
}

