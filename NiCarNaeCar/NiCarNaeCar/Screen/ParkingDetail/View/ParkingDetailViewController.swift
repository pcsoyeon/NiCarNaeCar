//
//  ParkingDetailViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/19.
//

import UIKit

import SnapKit
import Then

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class ParkingDetailViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.closeButtonIsHidden = true
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = R.Color.white
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
    }
    
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    // MARK: - Property
    
    var paringDetailInfo: ParkingDetailInfo?
    private var parkingLot = ParkingLot()
    private var viewModel = ParkingDetailViewModel()
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let info = paringDetailInfo {
            bindData(info)
        }
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        view.backgroundColor = R.Color.white
//        configureCollectionView()
    }
    
    override func setLayout() {
        view.addSubviews(navigationBar, collectionView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
//    private func configureCollectionView() {
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
    
    // MARK: - Data
    
    private func bindData(_ item: ParkingDetailInfo) {
        dump(item)
        parkingLot.location.name = item.parkingName
        parkingLot.location.address = item.addr
        
        viewModel.info.value = parkingLot
    }
}

extension ParkingDetailViewController: UICollectionViewDelegateFlowLayout {
    
}

extension ParkingDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
