//
//  MainSearchViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import RxCocoa
import RxSwift

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
        $0.backgroundImage = UIImage()
    }

    // MARK: - Property
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    var locationClosure: ((String) -> Void)?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
        searchBar.tintColor = R.Color.black200
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.tintColor = R.Color.black200
            textfield.backgroundColor = R.Color.gray400
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : R.Color.gray200])
            textfield.textColor = R.Color.black200
        }
    }
    
    private func configureTableView() {
        rootView.tableView.rowHeight = 60
        
        rootView.tableView.register(MainSearchTableViewCell.self, forCellReuseIdentifier: MainSearchTableViewCell.reuseIdentifier)
    }
    
    private func bind() {
        viewModel.filteredLocation.accept(viewModel.location)
        
        viewModel.filteredLocation
            .withUnretained(self)
            .bind { vc, location in
                vc.rootView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .debounce(RxTimeInterval.microseconds(5), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, value in
                if value != "" {
                    vc.viewModel.isFiltering.accept(true)
                    vc.viewModel.filterLocation(value)
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .withUnretained(self)
            .bind { vc, _ in
                vc.searchBar.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        viewModel.filteredLocation
            .bind(to: rootView.tableView.rx.items(cellIdentifier: MainSearchTableViewCell.reuseIdentifier, cellType: MainSearchTableViewCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                
                if let text = self.searchBar.text {
                    if self.viewModel.isFiltering.value {
                        cell.setData(item, true, text)
                    } else {
                        cell.setData(item, false, text)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        rootView.tableView.rx
            .itemSelected
            .withUnretained(self)
            .subscribe(onNext:  { (vc, value) in
                vc.locationClosure?(vc.viewModel.filteredLocation.value[value.row])
                vc.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
