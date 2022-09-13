//
//  MainSheetPresentationController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit

import NiCarNaeCar_Util
import CoreLocation

final class MainSheetViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainSheetView()
    
    // MARK: - Property
    
    var carList: [BrandInfo] = [BrandInfo(brandType: .socar, totalCount: "0", availableCount: "0"),
                                        BrandInfo(brandType: .greencar, totalCount: "0", availableCount: "0")] {
        didSet {
            DispatchQueue.main.async {
                self.rootView.collectionView.reloadData()
            }
        }
    }
    
    var positionId: Int = 0
    
    var item: [String:String] = [:]
    var elements: [String:String] = [:]
    var currentElement = ""
    
    private var positionName: String = ""
    private var address: String = ""
    
    var currentLatitude: Double = 0.0
    var currentLongtitude: Double = 0.0
    
    // MARK: - Life Cycle
    
    override func loadView() {
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        fetchSpotInfo()
        fetchSocarInfo()
        fetchGreencarInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        configureCollectionView()
        configureSheet()
    }
    
    private func configureCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        
        rootView.collectionView.register(MainSheetCollectionViewCell.self, forCellWithReuseIdentifier: MainSheetCollectionViewCell.reuseIdentifier)
    }
    
    private func configureSheet() {
        isModalInPresentation = false
        
        if let sheet = sheetPresentationController {
            sheet.detents = [.medium(), .large()]
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
}

// MARK: - UICollectionView Protocol

extension MainSheetViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        if indexPath.row == 0 {
            viewController.brandType = .socar
            viewController.info = carList[0]
        } else {
            viewController.brandType = .greencar
            viewController.info = carList[1]
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
        cell.setData(carList[indexPath.row].brandType, carList[indexPath.row].availableCount)
        return cell
    }
}

// MARK: - Network

extension MainSheetViewController {
    func fetchSpotInfo() {
        SpotAPIManager.requestSpotWithPositionId(startPage: 1, endPage: 900, positionId: positionId) { response in
            self.carList[0].carType = self.changeStringToCarType(response.nanumcarSpotList.row[0].elctyvhcleAt)
            self.carList[1].carType = self.changeStringToCarType(response.nanumcarSpotList.row[0].elctyvhcleAt)
            
            DispatchQueue.main.async {
                self.positionName = response.nanumcarSpotList.row[0].positnNm
                self.rootView.positionName = response.nanumcarSpotList.row[0].positnNm
                
                self.address = response.nanumcarSpotList.row[0].adres
                self.rootView.address = response.nanumcarSpotList.row[0].adres
                
                if let latitude = Double(response.nanumcarSpotList.row[0].la), let longtitude = Double(response.nanumcarSpotList.row[0].lo) {
                    self.rootView.distance = CLLocationCoordinate2D(latitude: self.currentLatitude, longitude: self.currentLongtitude).distanceToString(to: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude))
                }
            }
        }
    }
    
    private func fetchSocarInfo() {
        requestSocarList(startPage: 1, endPage: 500, spot: positionId)
    }
    
    private func fetchGreencarInfo() {
        requestGreencarList(startPage: 1, endPage: 500, spot: positionId)
    }
}

// MARK: - XMLParser Delegate

extension MainSheetViewController: XMLParserDelegate {
    func requestSocarList(startPage: Int, endPage: Int, spot: Int) {
        let urlString = EndPoint.carListSO.requestURL + "/\(startPage)/\(endPage)/\(spot)/so"
        
        guard let url = URL(string: urlString) else { return }
        
        if let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            
            if parser.parse() {
                if let totalCount = elements["reservAbleAllCnt"], let availableCount = elements["reservAbleCnt"] {
                    carList[0] = BrandInfo(brandType: .socar, totalCount: totalCount, availableCount: availableCount)
                }

            } else {
                print("============================== 🔴 Parse Failed 🔴 ==============================")
            }
        }
    }
    
    func requestGreencarList(startPage: Int, endPage: Int, spot: Int) {
        let urlString = EndPoint.carListGR.requestURL + "/\(startPage)/\(endPage)/\(spot)/gr"
        
        guard let url = URL(string: urlString) else { return }
        
        if let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            
            if parser.parse() {
                if let totalCount = elements["reservAbleAllCnt"], let availableCount = elements["reservAbleCnt"] {
                    carList[1] = BrandInfo(brandType: .greencar, totalCount: totalCount, availableCount: availableCount)
                }
            } else {
                print("============================== 🔴 Parse Failed 🔴 ==============================")
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
