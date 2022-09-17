//
//  SettingViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit
import SafariServices

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class SettingViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.viewType = .setting
        $0.backButtonIsHidden = false
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
}

// MARK: - UITableView Protocol

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            transition(SettingNameController(), transitionStyle: .presentFullScreen)
        case 1, 3, 4:
            pushToNotion()
        case 2:
            print("문의하기")
        default: return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let name = UserDefaults.standard.string(forKey: Constant.UserDefaults.userName) else { return nil }
            headerView.setData(title: name, subTitle: "내 정보 수정하기")
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
        cell.selectionStyle = .none
        
        return cell
    }
}
