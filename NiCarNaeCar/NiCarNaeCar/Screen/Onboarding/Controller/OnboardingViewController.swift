//
//  ViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit

import NiCarNaeCar_Resource
import NiCarNaeCar_Util

import SnapKit
import Then

final class OnboardingViewController: BaseViewController {

    // MARK: - UI Property
    
    let rootView = OnboardingView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureButton()
    }
    
    override func setLayout() {
        
    }
    
    private func configureButton() {
        rootView.delegate = self
    }
}

// MARK: - Custom Delegate

extension OnboardingViewController: OnboardingViewDelegate {
    func touchUpStartButton() {
        transition(OnboardingNameViewController(), transitionStyle: .push)
    }
}
