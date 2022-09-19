//
//  MainSheetPresentationController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit
import CoreLocation

import NiCarNaeCar_Util

final class MainSheetViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainSheetView()
    
    // MARK: - Property
    
    var socarInfo: BrandInfo = BrandInfo(brandType: .socar, totalCount: "0", availableCount: "0") {
        didSet {
            DispatchQueue.main.async {
                self.rootView.collectionView.reloadData()
            }
        }
    }
    
    var greencarInfo: BrandInfo = BrandInfo(brandType: .greencar, totalCount: "0", availableCount: "0") {
        didSet {
            DispatchQueue.main.async {
                self.rootView.collectionView.reloadData()
            }
        }
    }
    
    var positionId: Int = 0
    
    private var item: [String:String] = [:]
    private var elements: [String:String] = [:]
    private var currentElement = ""
    
    private var positionName: String = ""
    private var address: String = ""
    
    var currentLatitude: Double = 0.0
    var currentLongtitude: Double = 0.0
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        fetchSpotInfo()
        fetchSocarInfo()
        fetchGreencarInfo()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureCollectionView()
        configureSheet()
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(MainSheetCollectionViewCell.self, forCellWithReuseIdentifier: MainSheetCollectionViewCell.reuseIdentifier)
    }
    
    private func configureSheet() {
        isModalInPresentation = false
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.selectedDetentIdentifier = .medium
            sheet.largestUndimmedDetentIdentifier = .none
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
    }
    
    private func changeStringToCarType(_ data: String) -> CarType {
        if data == "TO" {
            return .TO
        } else if data == "EV" {
            return .EV
        } else {
            return .GA
        }
    }
    
    private func calculateDistance(_ spotInfo: Row) {
        if let latitude = Double(spotInfo.la), let longtitude = Double(spotInfo.lo) {
            let arrival: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.currentLatitude, longitude: self.currentLongtitude)
            let departure: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            
            self.rootView.distance = arrival.distanceToString(to: departure)
        }
    }
}

// MARK: - UICollectionView Protocol

extension MainSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        if indexPath.row == 0 {
            viewController.brandType = .socar
            viewController.info = socarInfo
        } else {
            viewController.brandType = .greencar
            viewController.info = greencarInfo
        }
        viewController.positionName = positionName
        viewController.address = address
        transition(viewController, transitionStyle: .presentFullScreen)
    }
}

extension MainSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 193)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
}

extension MainSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainSheetCollectionViewCell.reuseIdentifier, for: indexPath) as? MainSheetCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            cell.setData(socarInfo.brandType, socarInfo.availableCount)
        } else if indexPath.row == 1 {
            cell.setData(greencarInfo.brandType, greencarInfo.availableCount)
        }
        return cell
    }
}

// MARK: - Network

extension MainSheetViewController {
    func fetchSpotInfo() {
        view.isUserInteractionEnabled = false
        
        SpotAPIManager.requestSpotWithPositionId(startPage: 1, endPage: 5, positionId: positionId) { response, error in
            guard let response = response else { return }
            let spotInfo = response.nanumcarSpotList.row[0]
            
            self.socarInfo.carType = self.changeStringToCarType(spotInfo.elctyvhcleAt)
            self.greencarInfo.carType = self.changeStringToCarType(spotInfo.elctyvhcleAt)
            
            self.positionName = spotInfo.positnNm
            self.rootView.positionName = spotInfo.positnNm
            
            self.address = spotInfo.adres
            self.rootView.address = spotInfo.adres
            
            DispatchQueue.main.async {
                self.calculateDistance(spotInfo)
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    private func fetchSocarInfo() {
        requestSocarList(startPage: 1, endPage: 5, spot: positionId)
    }
    
    private func fetchGreencarInfo() {
        requestGreencarList(startPage: 1, endPage: 5, spot: positionId)
    }
}

// MARK: - XMLParser Delegate

extension MainSheetViewController: XMLParserDelegate {
    func requestSocarList(startPage: Int, endPage: Int, spot: Int) {
        let urlString = EndPoint.carListSO.requestURL + "/\(startPage)/\(endPage)/\(spot)/so"
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                
                if parser.parse() {
                    if let totalCount = self.elements["reservAbleAllCnt"], let availableCount = self.elements["reservAbleCnt"] {
                        self.socarInfo = BrandInfo(brandType: .socar, totalCount: totalCount, availableCount: availableCount)
                    }
                } else {
                    print("🔴 SOCAR XML Parse Failed 🔴")
                }
            }
        }
    }
    
    func requestGreencarList(startPage: Int, endPage: Int, spot: Int) {
        let urlString = EndPoint.carListGR.requestURL + "/\(startPage)/\(endPage)/\(spot)/gr"
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                
                if parser.parse() {
                    if let totalCount = self.elements["reservAbleAllCnt"], let availableCount = self.elements["reservAbleCnt"] {
                        self.greencarInfo = BrandInfo(brandType: .greencar, totalCount: totalCount, availableCount: availableCount)
                    }
                } else {
                    print("🔴 GREENCAR XML Parse Failed 🔴")
                }
            }
        }
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
//        print("currentElement = \(elementName)")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
//        print("data = \(data)")
        if !data.isEmpty {
            item[currentElement] = data
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "reservAbleCnt" {
            elements = item
        }
    }
}
