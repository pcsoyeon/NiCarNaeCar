//
//  MainSearchView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import UIKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class MainSearchView: BaseView {
    
    // MARK: - UI Property
    
    lazy var tableView = UITableView().then {
        $0.backgroundColor = R.Color.white
        $0.separatorColor = R.Color.gray400
        $0.separatorInset = UIEdgeInsets(top: 0, left: Metric.margin, bottom: 0, right: Metric.margin)
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        backgroundColor = R.Color.white
    }
    
    override func setLayout() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Metric.navigationHeight)
            make.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
