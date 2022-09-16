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
    
    var tableView = UITableView().then {
        $0.backgroundColor = R.Color.white
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
