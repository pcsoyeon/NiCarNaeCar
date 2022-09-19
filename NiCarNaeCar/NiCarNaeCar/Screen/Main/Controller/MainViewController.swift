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

enum SearchType {
    case locality
    case subLocality
    
    var index: Int {
        switch self {
        case .locality:
            return 1
        case .subLocality:
            return 2
        }
    }
}

final class MainViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainView()
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var annotation = MKPointAnnotation()
    
    private var currentLatitude: Double?
    private var currentLongtitude: Double?
    
    private var spotList: [Row] = [] {
        didSet {
            for spot in spotList {
                DispatchQueue.main.async {
                    guard let latitude = Double(spot.la) else { return }
                    guard let longtitude = Double(spot.lo) else { return }
                    
                    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    self.setAnnotation(center: center, title: spot.positnNm)
                }
            }
            
        }
    }
    
    private var positionId: Int = 0
    
    private var selectedLocality: String = ""
    private var currentSublocality: String = ""
    
    private var locationUpdateCount: Int = 0 {
        didSet {
            if locationUpdateCount == 1 {
                self.fetchSpotList(.subLocality, startPage: 1, endPage: 1000)
                self.fetchSpotList(.subLocality, startPage: 1001, endPage: 1870)
            }
        }
    }
    
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
        let overlays = self.rootView.mapView.overlays
        for overlay in overlays {
            self.rootView.mapView.removeOverlay(overlay)
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
    
    private func refreshSpotListAndAnnotation() {
        spotList.removeAll()
        
        rootView.mapView.annotations.forEach {
            if !($0.title == Constant.Annotation.currentLocationTitle) {
              self.rootView.mapView.removeAnnotation($0)
          }
        }
    }
    
    private func convertLocationToSublocality(_ location: CLLocation){
        let geocoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        
        geocoder.reverseGeocodeLocation(location, preferredLocale: locale, completionHandler: {(placemarks, error) in
            if let address: [CLPlacemark] = placemarks {
                if let result: String = address.last?.subLocality {
                    self.currentSublocality = result
                }
            }
        })
    }
}

// MARK: - MapView Protocol

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            guard let title = annotationTitle else { return }
            for spot in spotList {
                if spot.positnNm == title {
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
            transition(viewController, transitionStyle: .presentNavigation) { _ in
                viewController.positionId = self.positionId
                viewController.currentLatitude = self.currentLatitude ?? 0.0
                viewController.currentLongtitude = self.currentLongtitude ?? 0.0
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation.title == Constant.Annotation.currentLocationTitle {
            annotationView.markerTintColor = .systemRed
            return annotationView
        } else {
            annotationView.markerTintColor = R.Color.black200
            if #available(iOS 16.0, *) {
                if let featureAnnoation = annotation as? MKMapFeatureAnnotation {
                    annotationView.selectedGlyphImage = featureAnnoation.iconStyle?.image
                    annotationView.glyphImage = featureAnnoation.iconStyle?.image
                }
            }
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let gradientColors = [R.Color.green100.cgColor, R.Color.blue100.cgColor]
        let polylineRenderer = GradientPathRenderer(polyline: overlay as! MKPolyline, colors: gradientColors)
        polylineRenderer.lineWidth = 5
        return polylineRenderer
    }
}

// MARK: - Authorization Method

extension MainViewController {
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
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default)
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        present(requestLocationServiceAlert, animated: true, completion: nil)
    }
}

// MARK: - CLLocation Protocol

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            currentLatitude = coordinate.latitude
            currentLongtitude = coordinate.longitude
            
            setRegion(center: coordinate, meters: 1200)
            setAnnotation(center: coordinate, title: Constant.Annotation.currentLocationTitle)
            
            locationUpdateCount += 1
            convertLocationToSublocality(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
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

extension MainViewController: MainViewDelegate {
    func touchUpSearchButton() {
        let viewController = MainSearchViewController()
        viewController.locationClosure = { locality in
            self.selectedLocality = locality
            self.fetchSpotList(.locality, startPage: 1, endPage: 1000)
            self.fetchSpotList(.locality, startPage: 1001, endPage: 1870)
            
            for locality in LocalityType.allCases {
                if self.selectedLocality == locality.rawValue {
                    let center = locality.location
                    self.setRegion(center: center, meters: 8000)
                }
            }
        }
        transition(viewController, transitionStyle: .push)
    }
    
    func touchUpRefreshButton() {
        refreshSpotListAndAnnotation()
    }
    
    func touchUpCurrentLocationButton() {
        if let latitude = currentLatitude, let longtitude = currentLongtitude {
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            setRegion(center: center, meters: 1200)
        }
    }
    
    func touchUpSettingButton() {
        let viewController = SettingViewController()
        transition(viewController, transitionStyle: .push)
    }
}

// MARK: - Network

extension MainViewController {
    
    private func fetchSpotList(_ searchType: SearchType, startPage: Int, endPage: Int) {
        
        self.refreshSpotListAndAnnotation()
        var list: [Row] = []
        
        DispatchQueue.global().async {
            
            SpotListAPIManager.requestSpotList(startPage: startPage, endPage: endPage) { data, error in
                guard let data = data else { return }
                
                for spot in data.nanumcarSpotList.row {
                    let addressArr = spot.adres.split(separator: " ")
                    let locality = String(addressArr[searchType.index])
                    
                    switch searchType {
                    case .locality:
                        if locality == self.selectedLocality {
                            list.append(spot)
                        }
                    case .subLocality:
                        if locality == self.currentSublocality {
                            list.append(spot)
                        }
                    }
                }
                self.spotList = list
            }
        }
        
        
    }
}
