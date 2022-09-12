//
//  DetailViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

class DetailViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = DetailView()
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.viewType = .detail
        $0.backButtonIsHidden = true
    }
    
    // MARK: - Property
    
    var brandType: BrandType = .socar {
        didSet {
            rootView.openButton.backgroundColor = brandType.color
        }
    }
    
    var info: BrandInfo?
    
    var positionName: String = ""
    
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
        dump(info)
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
    
    private func configureButton() {
        rootView.delegate = self
    }
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(DetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: DetailHeaderView.identifier)
        rootView.collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.reuseIdentifier)
    }
}

// MARK: - Custom Delegate

extension DetailViewController: DetailViewDelegate {
    func touchUpOpenButton() {
        var url = ""
        
        if brandType == .socar {
            url = "socar:"
        } else {
            url = "greencar:"
        }
        
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(openApp, options: [:], completionHandler: nil)
            }
        } else {
            presentAlert(title: "\(brandType.brandNameKR)앱을 설치해주세요")
            print("링크 주소 : \(url)")
        }
    }
}

// MARK: - UICollectionView Protocol

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DetailHeaderView.identifier, for: indexPath) as? DetailHeaderView else { return UICollectionReusableView() }
        headerView.brandType = brandType
        headerView.carType = info?.carType?.text ?? ""
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 118)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.reuseIdentifier, for: indexPath) as? DetailCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.setData(brandType, positionName, nil, indexPath.row)
        } else if indexPath.row == 1 {
            cell.setData(brandType, "전체 차량 수", info?.totalCount, indexPath.row)
        } else {
            cell.setData(brandType, "예약 가능 차량 수", info?.availableCount, indexPath.row)
        }
        return cell
    }
}
