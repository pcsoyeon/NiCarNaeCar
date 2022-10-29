//
//  MainSearchViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class MainSearchViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainSearchView()
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.backButtonIsHidden = false
        $0.closeButtonIsHidden = true
        $0.addSubview(searchBar)
    }
    
    private lazy var searchBar = UISearchBar().then {
        $0.placeholder = "행정구를 검색해보세요"
        $0.delegate = self
        $0.backgroundImage = UIImage()
    }

    // MARK: - Property
    
    private var viewModel = SearchViewModel()
    
    var locationClosure: ((String) -> Void)?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        super.configureUI()
        view.backgroundColor = R.Color.white
        configureNavigation()
        configureSearchBar()
        configureTableView()
    }
    
    override func setLayout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.margin)
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    private func configureSearchBar() {
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
        searchBar.tintColor = R.Color.black200
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.tintColor = R.Color.black200
            textfield.backgroundColor = R.Color.gray400
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : R.Color.gray200])
            textfield.textColor = R.Color.black200
        }
    }
    
    private func configureTableView() {
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        rootView.tableView.register(MainSearchTableViewCell.self, forCellReuseIdentifier: MainSearchTableViewCell.reuseIdentifier)
    }
    
    private func bind() {
        viewModel.location.bind { [weak self] location in
            guard let self = self else { return }
            self.rootView.tableView.reloadData()
        }
        
        viewModel.filteredLocation.bind { [weak self] location in
            guard let self = self else { return }
            self.rootView.tableView.reloadData()
        }
    }
}

// MARK: - UISearchBar Protocol

extension MainSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.isFiltering.value = true
        
        guard let text = searchBar.text else { return }
        viewModel.filteredLocation.value = viewModel.location.value.filter { $0.contains(text) }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let text = searchBar.text else { return }
        viewModel.filteredLocation.value = viewModel.location.value.filter { $0.contains(text) }
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableView Protocol

extension MainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRowAt
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.isFiltering.value {
            locationClosure?(viewModel.filteredLocation.value[indexPath.row])
        } else {
            locationClosure?(viewModel.location.value[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
    }
}

extension MainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.reuseIdentifier, for: indexPath) as? MainSearchTableViewCell else { return UITableViewCell() }
        
        let data = viewModel.cellForRowAt(at: indexPath)
        if let text = searchBar.text {
            if viewModel.isFiltering.value {
                cell.setData(data, true, text)
            } else {
                cell.setData(data, false, text)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
