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
        $0.backButtonIsHidden = true
        $0.closeButtonIsHidden = false
        $0.title = "주차장 정보"
        $0.isDetail = true
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.backgroundColor = R.Color.white
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true
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
        configureCollectionView()
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
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ParkingDetailCollectionViewCell.self, forCellWithReuseIdentifier: ParkingDetailCollectionViewCell.reuseIdentifier)
        collectionView.register(ParkingDetailLocationCollectionViewCell.self, forCellWithReuseIdentifier: ParkingDetailLocationCollectionViewCell.reuseIdentifier)
        collectionView.register(ParkingDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ParkingDetailHeaderView.reuseIdentifier)
    }
    
    // MARK: - Data
    
    private func bindData(_ item: ParkingDetailInfo) {
        viewModel.fetchParkingDetailInfo(item)
    }
}

extension ParkingDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ParkingDetailHeaderView.reuseIdentifier, for: indexPath) as? ParkingDetailHeaderView else { return UICollectionReusableView() }
        
        viewModel.titleForSection(indexPath.section, headerView)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return viewModel.referenceSizeForHeaderInSection(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.sizeForItemAt(at: indexPath.section)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension ParkingDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = viewModel.cellForItemAt(indexPath.section)
        let title = item.0
        let data = item.1
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParkingDetailLocationCollectionViewCell.reuseIdentifier, for: indexPath) as? ParkingDetailLocationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setData(data[0], data[1])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParkingDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? ParkingDetailCollectionViewCell else {
                return UICollectionViewCell()
            }
            if let title = title {
                cell.setData(title[indexPath.item], data[indexPath.item])
            }
            return cell
        }
    }
}
