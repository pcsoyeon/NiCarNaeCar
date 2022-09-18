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

final class MainViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainView()
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var annotation = MKPointAnnotation()
    
    private var currentLatitude: Double?
    private var currentLongtitude: Double?
    
    private var spotList: [Row] = []
    
    private var currentPage: Int = 1
    private var endPage: Int = 30
    private var totalPage: Int = 100
    
    private var positionId: Int = 0
    
    private var selectedLocality: String = ""
    
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
        addSpotListAnnotation()
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
        currentPage = 1
        endPage = 30
        spotList.removeAll()
        
        rootView.mapView.annotations.forEach {
            if !($0.title == Constant.Annotation.currentLocationTitle) {
              self.rootView.mapView.removeAnnotation($0)
          }
        }
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
        if annotation.title == Constant.Annotation.currentLocationTitle {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = .systemRed
            return annotationView
        } else {
            let annotationView = DefaultAnnoationView(annotation: annotation, reuseIdentifier: DefaultAnnoationView.ReuseID)
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
            setAnnotation(center: coordinate, title: "나의 현재 위치")
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
    func touchUpSearchBarButton() {
        let viewController = MainSearchViewController()
        viewController.locationClosure = { locality in
            self.selectedLocality = locality
            self.fetchLocalitySpot()
        }
        transition(viewController, transitionStyle: .push)
    }
    
    func touchUpRefreshButton() {
        refreshSpotListAndAnnotation()
    }
    
    func touchUpAddButton() {
        currentPage += 30
        endPage += 30
        
        if let latitude = self.currentLatitude, let longtitude = self.currentLongtitude {
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            let meters = CLLocationDistance(2000 + self.currentPage * 80)
            
            setRegion(center: center, meters: meters)
        }
        
        addSpotListAnnotation()
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
    private func addSpotListAnnotation() {
        if endPage <= totalPage {
            SpotListAPIManager.requestSpotList(startPage: currentPage, endPage: endPage) { data, error in
                guard let data = data else { return }
                
                self.totalPage = data.nanumcarSpotList.listTotalCount
                
                DispatchQueue.main.async {
                    for spot in data.nanumcarSpotList.row {
                        self.spotList.append(spot)
                        
                        guard let latitude = Double(spot.la) else { return }
                        guard let longtitude = Double(spot.lo) else { return }
                        
                        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                        self.setAnnotation(center: center, title: spot.positnNm)
                    }
                }
            }
        }
    }
    
    private func fetchLocalitySpot() {
        SpotListAPIManager.requestSpotList(startPage: 1, endPage: 500) { data, error in
            guard let data = data else { return }
            
            self.refreshSpotListAndAnnotation()
            
            DispatchQueue.main.async {
                for spot in data.nanumcarSpotList.row {
                    let addressArr = spot.adres.split(separator: " ")
                    let locality = String(addressArr[1])
                    
                    if locality == self.selectedLocality {
                        self.spotList.append(spot)
                        
                        guard let latitude = Double(spot.la) else { return }
                        guard let longtitude = Double(spot.lo) else { return }
                        
                        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                        self.setAnnotation(center: center, title: spot.positnNm)
                    }
                }
            }
        }
        
        for locality in LocalityType.allCases {
            if selectedLocality == locality.rawValue {
                let center = locality.location
                setRegion(center: center, meters: 8000)
            }
        }
    }
}
