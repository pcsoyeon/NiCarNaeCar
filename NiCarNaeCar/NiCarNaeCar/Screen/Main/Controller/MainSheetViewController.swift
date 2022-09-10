//
//  MainSheetPresentationController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit

import NiCarNaeCar_Util

final class MainSheetViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainSheetView()
    
    // MARK: - Property
    
    var dataSource = [BrandInfo]() {
        didSet {
            rootView.collectionView.reloadData()
        }
    }
    
    var positionId: Int = 0
    var positionName: String = "" {
        didSet {
            rootView.positionName = positionName
        }
    }
    
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
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureCollectionView()
        configureSheet()
    }
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(MainSheetCollectionViewCell.self, forCellWithReuseIdentifier: MainSheetCollectionViewCell.reuseIdentifier)
    }
    
    private func configureSheet() {
        isModalInPresentation = false
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .none
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
    }
}

// MARK: - UICollectionView Protocol

extension MainSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        if indexPath.row == 0 {
            viewController.carType = .socar
            viewController.info = dataSource[0]
        } else {
            viewController.carType = .greencar
            viewController.info = dataSource[1]
        }
        transition(viewController, transitionStyle: .presentFullScreen)
    }
}

extension MainSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 193)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension MainSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSheetCollectionViewCell.reuseIdentifier, for: indexPath) as? MainSheetCollectionViewCell else { return UICollectionViewCell() }
        cell.setData(dataSource[indexPath.row].carType, dataSource[indexPath.row].availableCount)
        return cell
    }
}
