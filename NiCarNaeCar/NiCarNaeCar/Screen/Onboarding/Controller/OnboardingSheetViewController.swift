//
//  OnboardingSheetViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/10.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class OnboardingSheetViewController: BaseViewController {

    // MARK: - UI Property
    
    private let rootView = OnboardingSheetView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureUI() {
        configureSheet()
        configureButton()
    }
    
    private func configureSheet() {
        isModalInPresentation = true
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .none
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 20
        }
    }
    
    private func configureButton() {
        rootView.delegate = self
    }
}

// MARK: - Custom Delegate

extension OnboardingSheetViewController: OnboardingSheetViewDelegate {
    func touchUpStartButton() {
        transition(OnboardingNameViewController(), transitionStyle: .presentFullScreen)
    }
}
