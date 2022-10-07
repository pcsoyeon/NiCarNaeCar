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
        $0.viewType = .main
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
    
    var isFiltering: Bool = false

    var location = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]
    var filterredLocation: [String] = [""]
    
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
        
        searchBar.setValue("취소", forKey: "cancelButtonText")
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
}

// MARK: - UISearchBar Protocol

extension MainSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isFiltering = true
        
        guard let text = searchBar.text else { return }
        self.filterredLocation = self.location.filter { $0.contains(text) }
       
        rootView.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()

        guard let text = searchBar.text else { return }
        self.filterredLocation = self.location.filter { $0.contains(text) }
       
        rootView.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.isFiltering = false
        rootView.tableView.reloadData()
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableView Protocol

extension MainSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering {
            locationClosure?(filterredLocation[indexPath.row])
        } else {
            locationClosure?(location[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
    }
}

extension MainSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filterredLocation.count
        } else {
            return location.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainSearchTableViewCell.reuseIdentifier, for: indexPath) as? MainSearchTableViewCell else { return UITableViewCell() }
        
        if let text = searchBar.text {
            if isFiltering {
                cell.setData(filterredLocation[indexPath.row], true, text)
            } else {
                cell.setData(location[indexPath.row], false, text)
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
}
