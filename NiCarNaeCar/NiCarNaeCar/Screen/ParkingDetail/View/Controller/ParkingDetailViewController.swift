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
    
    enum Item: Hashable {
        case location(String, String)
        
        case defatultFee(String)
        case additionalFee(String)
        
        case isWeekdayFree(String)
        case isSaturdayFree(String)
        case isHolidayFree(String)
        
        case weekdayOperatingTime(String)
        case saturdayOperatingTime(String)
        case holidayOperatingTime(String)
        
        case contact(String)
    }
    
    // MARK: - UI Property
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.backButtonIsHidden = true
        $0.closeButtonIsHidden = false
        $0.title = "주차장 정보"
        $0.isDetail = true
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = R.Color.white
        $0.contentInsetAdjustmentBehavior = .never
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true
    }
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Item>!
    
    // MARK: - Property
    
    var paringDetailInfo: ParkingDetailInfo?
    private var viewModel = ParkingDetailViewModel()
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        view.backgroundColor = R.Color.white
        configureDataSource()
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
    
    // MARK: - Data
    
    private func bindData() {
        if let info = paringDetailInfo {
            viewModel.fetchParkingDetailInfo(info)
        }
        
        viewModel.parkingLot.bind { [weak self] parkinglot in
            var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
            
            guard let self = self else { return }
            
            snapshot.appendSections([0, 1, 2, 3, 4])
            
            snapshot.appendItems([Item.location(parkinglot.name, parkinglot.location)], toSection: 0)
            
            snapshot.appendItems([Item.defatultFee(parkinglot.defaultFee),
                                  Item.additionalFee(parkinglot.additionalFee)], toSection: 1)
            
            snapshot.appendItems([Item.isWeekdayFree(parkinglot.isWeekdayFree),
                                  Item.isSaturdayFree(parkinglot.isSaturdayFree),
                                  Item.isHolidayFree(parkinglot.isHolidayFree)], toSection: 2)
            
            snapshot.appendItems([Item.weekdayOperatingTime(parkinglot.weekdayOperatingTime),
                                  Item.saturdayOperatingTime(parkinglot.saturdayOperatingTime),
                                  Item.holidayOperatingTime(parkinglot.holidayOperatingTime)], toSection: 3)
            
            snapshot.appendItems([Item.contact(parkinglot.contact)], toSection: 4)
            self.dataSource.apply(snapshot)
        }
    }
}

// MARK: - CollectionView

extension ParkingDetailViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            if sectionIndex == 0 {
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(109))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(0))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: ParkingDetailViewController.sectionHeaderElementKind,
                    alignment: .bottom
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                return section
            } else {
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitems: [item])
                
                let headerSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(60))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: ParkingDetailViewController.sectionHeaderElementKind,
                    alignment: .top
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = createCompositionalLayout()
        layout.configuration = configuration
        return layout
    }
    
    private func configureDataSource() {
        let locationCellRegistration = UICollectionView.CellRegistration<ParkingDetailLocationCollectionViewCell, (String, String)> { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier.0, itemIdentifier.1)
        }
        
        let cellRegistration = UICollectionView.CellRegistration<ParkingDetailCollectionViewCell, String> { cell, indexPath, itemIdentifier in
            if indexPath.section == 1 {
                let arr = ["기본", "추가"]
                cell.setData(arr[indexPath.item], itemIdentifier)
            } else if indexPath.section == 2 || indexPath.section == 3 {
                let arr = ["평일", "토요일", "공휴일"]
                cell.setData(arr[indexPath.item], itemIdentifier)
            } else {
                cell.setData("주차장", itemIdentifier)
            }
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration
        <ParkingDetailHeaderView>(elementKind: ParkingDetailViewController.sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
            switch indexPath.section {
            case 1: supplementaryView.title = "요금"
            case 2: supplementaryView.title = "무/유료"
            case 3: supplementaryView.title = "운영시간"
            case 4: supplementaryView.title = "전화번호"
            default: return
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .location(let name, let location):
                let cell = collectionView.dequeueConfiguredReusableCell(using: locationCellRegistration, for: indexPath, item: (name, location))
                return cell
            case .defatultFee(let value), .additionalFee(let value):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: value)
                return cell
            case .isWeekdayFree(let value), .isSaturdayFree(let value), .isHolidayFree(let value):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: value)
                return cell
            case .weekdayOperatingTime(let value), .saturdayOperatingTime(let value), .holidayOperatingTime(let value):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: value)
                return cell
            case .contact(let value):
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: value)
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(
                using: headerRegistration, for: index)
        }
    }
}
