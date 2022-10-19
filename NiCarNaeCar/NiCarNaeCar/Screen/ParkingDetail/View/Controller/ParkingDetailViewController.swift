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
        dump(item)
        
        parkingLot.location.name = item.parkingName
        parkingLot.location.address = item.addr
        
        parkingLot.fee.defaultFee = "\(item.rates)원/\(item.timeRate)분"
        parkingLot.fee.additionalFee = "\(item.addRates)원/\(item.addTimeRate)분"
        
        parkingLot.free.isWeekdayFree = item.payNm
        parkingLot.free.isSaturdayFree = item.saturdayPayNm
        parkingLot.free.isHolidayFree = item.holidayPayNm
        
        parkingLot.operatingTime.weekdayOperatingTime = "\(item.weekdayBeginTime) ~ \(item.weekdayEndTime)"
        parkingLot.operatingTime.saturdayOperatingTime = "\(item.weekdayBeginTime) ~ \(item.weekdayEndTime)"
        parkingLot.operatingTime.holidayOperatingTime = "\(item.holidayBeginTime) ~ \(item.holidayEndTime)"
        
        parkingLot.contact.contact = item.tel
        
        viewModel.info.value = parkingLot
    }
}

extension ParkingDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ParkingDetailHeaderView.reuseIdentifier, for: indexPath) as? ParkingDetailHeaderView else { return UICollectionReusableView() }
        
        if indexPath.section == 1 {
            headerView.title = "요금"
        } else if indexPath.section == 2 {
            headerView.title = "무/유료"
        } else if indexPath.section == 3 {
            headerView.title = "운영시간"
        } else if indexPath.section == 4 {
            headerView.title = "전화번호"
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 0)
        } else {
            return CGSize(width: view.frame.width, height: 60)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 109)
        } else {
            return CGSize(width: view.frame.width, height: 60)
        }
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParkingDetailCollectionViewCell.reuseIdentifier, for: indexPath) as? ParkingDetailCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParkingDetailLocationCollectionViewCell.reuseIdentifier, for: indexPath) as? ParkingDetailLocationCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setData(parkingLot.location.name, parkingLot.location.address)
            return cell
        } else if indexPath.section == 1 {
            let title = ["기본", "추가"]
            let detail = [parkingLot.fee.defaultFee, parkingLot.fee.additionalFee]
            cell.setData(title[indexPath.item], detail[indexPath.item])
        } else if indexPath.section == 2 {
            let title = ["평일", "토요일", "공휴일"]
            let detail = [parkingLot.free.isWeekdayFree, parkingLot.free.isSaturdayFree, parkingLot.free.isHolidayFree]
            cell.setData(title[indexPath.item], detail[indexPath.item])
        } else if indexPath.section == 3 {
            let title = ["평일", "토요일", "공휴일"]
            let detail = [parkingLot.operatingTime.weekdayOperatingTime, parkingLot.operatingTime.saturdayOperatingTime, parkingLot.operatingTime.holidayOperatingTime]
            cell.setData(title[indexPath.item], detail[indexPath.item])
        } else if indexPath.section == 4 {
            let title = ["주차장"]
            let detail = [parkingLot.contact.contact]
            cell.setData(title[indexPath.item], detail[indexPath.item])
        }
        
        return cell
    }
}
