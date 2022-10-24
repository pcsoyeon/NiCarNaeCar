//
//  SettingViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit
import SafariServices
import MessageUI

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class SettingViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.title = "설정"
        $0.backButtonIsHidden = true
        $0.closeButtonIsHidden = true
    }
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = R.Color.white
        $0.delegate = self
    }
    
    // MARK: - Property
    
    private var viewModel = SettingViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Int, SettingList>!
    static let sectionHeaderElementKind = "section-header-element-kind"

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        bindData()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        view.backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        view.addSubviews(navigationBar, collectionView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Metric.navigationHeight)
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
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<SettingCollectionViewCell, SettingList>.init { cell, indexPath, itemIdentifier in
            cell.setData(itemIdentifier.title)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<SettingHeaderView>(elementKind: SettingViewController.sectionHeaderElementKind) { (supplementaryView, string, indexPath) in
            guard let name = UserDefaults.standard.string(forKey: Constant.UserDefaults.userName) else { return }
            supplementaryView.setData(name)
            supplementaryView.delegate = self 
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        })
        
        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }
    }
    
    // MARK: - Data
    
    private func bindData() {
        viewModel.setSettingList()
        
        viewModel.list.bind { [weak self] settingList in
            var snapshot = NSDiffableDataSourceSnapshot<Int, SettingList>()
            
            guard let self = self else { return }
            
            snapshot.appendSections([0])
            snapshot.appendItems(settingList, toSection: 0)
            
            self.dataSource.apply(snapshot)
        }
    }
    
    // MARK: - Custom Method
    
    private func pushToNotion() {
        guard let url = NSURL(string: URLConstant.NotionURL) else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url as URL)
        transition(safariView, transitionStyle: .present)
    }
    
    private func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let composeViewController = MFMailComposeViewController()
            composeViewController.mailComposeDelegate = self
            composeViewController.setToRecipients(["alice9809@naver.com"])
            composeViewController.setSubject("제목을 작성해주세요")
            composeViewController.setMessageBody("내용을 작성해주세요", isHTML: false)
            
            present(composeViewController, animated: true)
        } else {
            presentAlert(title: "메일 앱을 사용할 수 없어요")
        }
    }
    
    private func sendReview() {
        if let appstoreUrl = URL(string: "https://apps.apple.com/app/id\(APIKey.AppId)") {
            var urlComp = URLComponents(url: appstoreUrl, resolvingAgainstBaseURL: false)
            urlComp?.queryItems = [
                URLQueryItem(name: "action", value: "write-review")
            ]
            guard let reviewUrl = urlComp?.url else {
                return
            }
            UIApplication.shared.open(reviewUrl, options: [:], completionHandler: nil)
        }
    }
}

// MARK: - CollectionView

extension SettingViewController {
    private func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        let layout = createCompositionalLayout()
        layout.configuration = configuration
        return layout
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .absolute(65))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(118))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: SettingViewController.sectionHeaderElementKind,
                alignment: .top
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
}

// MARK: - UICollectionView Protocol

extension SettingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0, 3, 4:
            pushToNotion()
        case 2:
            sendReview()
        case 1:
            sendMail()
        default: return
        }
    }
}

// MARK: - Custom Delegate

extension SettingViewController: SettingHeaderViewDelegate {
    func touchUpButton() {
        let viewController = SettingNameController()
        viewController.closure = { name in
            self.collectionView.reloadData()
        }
        transition(viewController, transitionStyle: .presentFullScreen)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("메일 발송 성공")
        case .saved:
            print("메일 임시 저장")
        case .cancelled:
            print("메일 작성 취소")
        case .failed:
            print("메일 발송 실패")
        @unknown default:
            fatalError()
        }
        dismiss(animated: true)
    }
}
