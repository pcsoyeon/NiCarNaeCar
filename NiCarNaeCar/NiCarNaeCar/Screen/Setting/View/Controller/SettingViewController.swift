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
    
    private var tableView = UITableView().then {
        $0.backgroundColor = R.Color.white
    }
    
    private var headerView = SettingHeaderView()
    
    // MARK: - Property
    
    private var viewModel = SettingViewModel()

    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindData()
    }
    
    override func configureUI() {
        view.backgroundColor = R.Color.white
        configureTableView()
    }
    
    override func setLayout() {
        view.addSubviews(navigationBar, tableView)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(57)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.reuseIdentifier)
        
        tableView.separatorStyle = .none
    }
    
    private func bindData() {
        viewModel.fetchSetting()
    }
    
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

// MARK: - UITableView Protocol

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let name = UserDefaults.standard.string(forKey: Constant.UserDefaults.userName) else { return nil }
            headerView.setData(name)
            headerView.delegate = self
            return headerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeaderInSection(at: section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.heightForFooterInSection(at: section)
    }
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInsection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.reuseIdentifier, for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.cellForRowAt(at: indexPath)
        cell.setData(data.title, data.subTitle)
        
        return cell
    }
}

// MARK: - Custom Delegate

extension SettingViewController: SettingHeaderViewDelegate {
    func touchUpButton() {
        transition(SettingNameController(), transitionStyle: .presentFullScreen)
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            // 메일 발송 성공 ( 인터넷이 안되는 경우도 sent처리되고, 인터넷이 연결되면 메일이 발송됨. )
            print("메일 발송 성공")
        case .saved:
            // 메일 임시 저장
            print("메일 임시 저장")
        case .cancelled:
            // 메일 작성 취소
            print("메일 작성 취소")
        case .failed:
            // 메일 발송 실패 (오류 발생)
            print("메일 발송 실패")
        @unknown default:
            fatalError()
        }
        dismiss(animated: true)
    }
}
