//
//  SettingViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/09.
//

import UIKit

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
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func bindData() {
        viewModel.fetchSetting()
    }
}

// MARK: - UITableView Protocol

extension SettingViewController: UITableViewDelegate {
    
}

extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInsection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let data = viewModel.cellForRowAt(at: indexPath)
        cell.textLabel?.text = data.title
        return cell
    }
}
