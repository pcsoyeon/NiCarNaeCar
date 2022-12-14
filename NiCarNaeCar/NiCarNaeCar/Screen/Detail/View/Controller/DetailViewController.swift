//
//  DetailViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import RxCocoa
import RxSwift

final class DetailViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = DetailView()
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.title = "예약 현황"
        $0.backButtonIsHidden = true
        $0.isDetail = true
    }
    
    // MARK: - Property
    
    let viewModel = DetailViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureButton()
        configureCollectionView()
    }
    
    override func setLayout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureButton() {
        rootView.delegate = self
    }
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderView.identifier)
        rootView.collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseIdentifier)
    }
    
    private func bind() {
        viewModel.brandType
            .asDriver()
            .drive(onNext: { [weak self] brandType in
                guard let self = self else { return }
                self.rootView.openButton.backgroundColor = brandType.color
            })
            .disposed(by: disposeBag)
        
        viewModel.info
            .asDriver()
            .drive(onNext: { [weak self] brandInfo in
                guard let self = self else { return }
                
                if brandInfo.availableCount == "0" {
                    self.rootView.hasData = false
                } else {
                    self.rootView.hasData = true
                    self.rootView.openButton.backgroundColor = self.viewModel.brandType.value.color
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Delegate

extension DetailViewController: DetailViewDelegate {
    func touchUpOpenButton() {
        let url = viewModel.openURL()
        
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            }
        } else {
            presentAlert(title: "\(self.viewModel.brandType.value.brandNameKR) 앱을 설치해주세요") { [weak self] _ in
                guard let self = self else { return }
                self.openURLByBrandType(self.viewModel.brandType.value)
            }
        }
    }
    
    private func openURLByBrandType(_ brandType: BrandType) {
        let appStoreURL = brandType == .socar ? URLConstant.SocarURL : URLConstant.GreencarURL
        
        if let openApp = URL(string: appStoreURL), UIApplication.shared.canOpenURL(openApp) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            }
        }
    }
}

// MARK: - UICollectionView Protocol

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeaderView.identifier, for: indexPath) as? DetailHeaderView else { return UICollectionReusableView() }
        headerView.brandType = viewModel.brandType.value
        headerView.carType = viewModel.info.value.carType.text
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 118)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            return CGSize(width: view.frame.width, height: 90)
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

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(at: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseIdentifier, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.cellForItemAt(at: indexPath)
        cell.setData(data.0, data.1, data.2, data.3, indexPath.row)
        return cell
    }
}
