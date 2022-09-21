//
//  NDSLoadingIndicator.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/21.
//

import UIKit

import NiCarNaeCar_Resource

final class LoadingIndicator {
    
    static func showLoading() {
        DispatchQueue.main.async {
            
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            if let window = window {
                let loadingIndicatorView: UIActivityIndicatorView
                if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                    loadingIndicatorView = existedView
                } else {
                    loadingIndicatorView = UIActivityIndicatorView(style: .large)
                    
                    // 다른 UI가 눌리지 않도록 indicatorView의 크기를 full로 할당
                    loadingIndicatorView.frame = window.frame
                    loadingIndicatorView.color = R.Color.black200
                    window.addSubview(loadingIndicatorView)
                }
                
                loadingIndicatorView.startAnimating()
            }
        }
    }
    
    static func hideLoading() {
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            if let window = window {
                window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
            }
        }
    }
}
