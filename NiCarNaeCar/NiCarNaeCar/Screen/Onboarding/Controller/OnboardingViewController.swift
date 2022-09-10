//
//  ViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit

import NiCarNaeCar_Resource
import NiCarNaeCar_Util

final class OnboardingViewController: BaseViewController {

    // MARK: - UI Property
    
    let rootView = OnboardingView()
    
    // MARK: - Property
    
    private var currentRow: Int = 0
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureButton()
        configureCollectionView()
    }
    
    private func configureButton() {
        rootView.delegate = self
    }
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(OnboardingTextCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingTextCollectionViewCell.reuseIdentifier)
        rootView.collectionView.register(OnboardingImageCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingImageCollectionViewCell.reuseIdentifier)
    }
}

// MARK: - Custom Delegate

extension OnboardingViewController: OnboardingViewDelegate {
    func touchUpStartButton() {
        if currentRow == 0 {
            rootView.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .right, animated: true)
            currentRow += 1
        } else if currentRow == 1 {
            print("PRESENT BOTTOM SHEET VIEW")
        }
    }
}

// MARK: - UICollectionView Protocol

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingImageCollectionViewCell.reuseIdentifier, for: indexPath) as? OnboardingImageCollectionViewCell else { return UICollectionViewCell() }
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingTextCollectionViewCell.reuseIdentifier, for: indexPath) as? OnboardingTextCollectionViewCell else { return UICollectionViewCell() }
            return cell
        default: return UICollectionViewCell()
        }
    }
}
