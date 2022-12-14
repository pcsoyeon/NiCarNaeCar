//
//  MainViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import UIKit
import CoreLocation
import MapKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

import SnapKit
import Then

final class MainMapViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainMapView()
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var annotation = MKPointAnnotation()
    
    private var currentLatitude: Double?
    private var currentLongtitude: Double?
    
    private var spotList: [Row] = []
    private var filteredList: [Row] = []
    
    private var positionId: Int = 0
    
    private var selectedLocality: String = ""
    private var currentSublocality: String = ""
    
    private var locationUpdateCount: Int = 0 {
        didSet {
            if locationUpdateCount == 1 {
                fetchAllSpotList()
            }
        }
    }
    
    private let dispatchGroup = DispatchGroup()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserCurrentLocationAuthorization(locationManager.authorizationStatus)
        setLocationManager()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        super.configureUI()
        configureMapView()
        configureButton()
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureMapView() {
        rootView.mapView.delegate = self
        rootView.mapView.showsCompass = false
        
        rootView.mapView.register(DefaultAnnoationView.self, forAnnotationViewWithReuseIdentifier: DefaultAnnoationView.ReuseID)
    }
    
    private func configureButton() {
        rootView.buttonDelegate = self
    }
    
    // MARK: - Custom Method
    
    private func setLocationManager() {
        locationManager.delegate = self
//        locationManager.distanceFilter = 100000
    }
    
    private func setRegion(center: CLLocationCoordinate2D, meters: CLLocationDistance) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: meters, longitudinalMeters: meters)
        rootView.mapView.setRegion(region, animated: true)
    }
    
    private func setAnnotation(center: CLLocationCoordinate2D, title: String) {
        let annotation =  MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        rootView.mapView.addAnnotation(annotation)
    }
    
    private func drawDistanceLine(to: CLLocationCoordinate2D, from: CLLocationCoordinate2D) {
        let overlays = rootView.mapView.overlays
        for overlay in overlays {
            rootView.mapView.removeOverlay(overlay)
        }
        
        let sourcePlaceMark = MKPlacemark(coordinate: to, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: from, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let direction = MKDirections(request: directionRequest)
        
        direction.calculate { response, error in
            guard let response = response else {
                if let error = error {
                    print("Error : \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.rootView.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
        }
    }
    
    private func removeAnnotations() {
        rootView.mapView.annotations.forEach {
            if !($0.title == Constant.Annotation.currentLocationTitle) {
              self.rootView.mapView.removeAnnotation($0)
          }
        }
    }
    
    private func removeMapViewOverlays() {
        let overlays = rootView.mapView.overlays
        rootView.mapView.removeOverlays(overlays)
    }
}

// MARK: - MapView Protocol

extension MainMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            
            if annotationTitle != Constant.Annotation.currentLocationTitle {
                for spot in filteredList {
                    if spot.positnNm == annotationTitle {
                        if let positionId = Int(spot.positnCD) {
                            self.positionId = positionId
                        }
                        
                        if let latitude = Double(spot.la), let longtitude = Double(spot.lo) {
                            let to = CLLocationCoordinate2D(latitude: currentLatitude ?? 0.0, longitude: currentLongtitude ?? 0.0)
                            let from = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                            drawDistanceLine(to: to, from: from)
                        }
                    }
                }
                
                let viewController = MainSheetViewController()
                transition(viewController, transitionStyle: .presentNavigation) { [weak self] _ in
                    guard let self = self else { return }
                    
                    viewController.positionId = self.positionId
                    viewController.currentLatitude = self.currentLatitude ?? 0.0
                    viewController.currentLongtitude = self.currentLongtitude ?? 0.0
                }
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title == Constant.Annotation.currentLocationTitle {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotationView.markerTintColor = .systemRed
            return annotationView
        } else {
            let annotationView = DefaultAnnoationView(annotation: annotation, reuseIdentifier: DefaultAnnoationView.ReuseID)
            annotationView.markerTintColor = R.Color.black200
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let gradientColors = [R.Color.green100.cgColor, R.Color.green100.cgColor, R.Color.blue100.cgColor]
        let polylineRenderer = GradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
}

// MARK: - Authorization Method

extension MainMapViewController {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            presentAlert(title: "")
            showRequestLocationServiceAlert()
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOT DETERMINED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
        let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        
        let setting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .default)
        
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(setting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

// MARK: - CLLocation Protocol

extension MainMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            currentLatitude = coordinate.latitude
            currentLongtitude = coordinate.longitude
            
            setRegion(center: coordinate, meters: 1200)
            setAnnotation(center: coordinate, title: Constant.Annotation.currentLocationTitle)
            
            locationUpdateCount += 1
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
}

// MARK: - Custom Delegate

extension MainMapViewController: MainMapViewDelegate {
    func touchUpSearchButton() {
        let viewController = MainSearchViewController()
        viewController.locationClosure = { locality in
            self.selectedLocality = locality
            
            self.removeAnnotations()
            self.removeMapViewOverlays()
            
            self.filterSpotList(.locality)
            
            for locality in LocalityType.allCases {
                if self.selectedLocality == locality.rawValue {
                    let center = locality.location
                    self.setRegion(center: center, meters: 8000)
                }
            }
        }
        transition(viewController, transitionStyle: .push)
    }
    
    func touchUpCurrentLocationButton() {
        if let latitude = currentLatitude, let longtitude = currentLongtitude {
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            setRegion(center: center, meters: 800)
        }
        
        filteredList.removeAll()
        removeAnnotations()
        
        filteredList = spotList
        for spot in filteredList {
            guard let latitude = Double(spot.la) else { return }
            guard let longtitude = Double(spot.lo) else { return }
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            self.setAnnotation(center: center, title: spot.positnNm)
        }
    }
    
    func touchUpSettingButton() {
        let viewController = SettingViewController()
        transition(viewController, transitionStyle: .push)
    }
}

// MARK: - Network

extension MainMapViewController {
    private func fetchAllSpotList() {
        self.fetchSpotList(startPage: 1, endPage: 1000)
        self.fetchSpotList(startPage: 1001, endPage: 1870)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            print("🔴 서버 통신 끝!!!")
            
            for spot in self.spotList {
                guard let latitude = Double(spot.la) else { return }
                guard let longtitude = Double(spot.lo) else { return }
                
                let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                self.setAnnotation(center: center, title: spot.positnNm)
            }
            
            self.filteredList = self.spotList
        }
    }
    
    private func fetchSpotList(startPage: Int, endPage: Int) {
        print("🟢 서버통신을 해볼게요???")
        
        dispatchGroup.enter()
        SpotListAPIManager.requestSpotList(startPage: startPage, endPage: endPage) { [weak self] data, error in
            guard let self = self else { return }
            guard let data = data else { return }
            
            for item in data.nanumcarSpotList.row {
                self.spotList.append(item)
            }
            self.dispatchGroup.leave()
        }
    }
    
    private func filterSpotList(_ searchType: SearchType) {
        filteredList.removeAll()
        
        for spot in spotList {
            let addressArr = spot.adres.split(separator: " ")
            let locality = String(addressArr[searchType.index])
            
            filteredList.append(spot)
            
            switch searchType {
            case .locality:
                if locality == selectedLocality {
                    guard let latitude = Double(spot.la) else { return }
                    guard let longtitude = Double(spot.lo) else { return }
                    
                    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    setAnnotation(center: center, title: spot.positnNm)
                }
            case .subLocality:
                if locality == currentSublocality {
                    guard let latitude = Double(spot.la) else { return }
                    guard let longtitude = Double(spot.lo) else { return }
                    
                    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    setAnnotation(center: center, title: spot.positnNm)
                }
            }
        }
    }
}

