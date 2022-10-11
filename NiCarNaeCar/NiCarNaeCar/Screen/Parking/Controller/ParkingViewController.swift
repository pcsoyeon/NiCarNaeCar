//
//  ParkingViewController.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/10/07.
//

import UIKit
import CoreLocation
import MapKit

import NiCarNaeCar_Util
import NiCarNaeCar_Resource

final class ParkingViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = ParkingMapView()
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var annotation = MKPointAnnotation()
    
    private var currentLatitude: Double?
    private var currentLongtitude: Double?
    
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
        
        ParkingAPIManager.requestParkingList(startPage: 1, endPage: 5) { data, error in
            guard let data = data else { return }
            
            dump(data)
        }
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
        locationManager.distanceFilter = 100000
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
}

// MARK: - Custom Delegate

extension ParkingViewController: ParkingMapViewDelegate {
    func touchUpCurrentLocationButton() {
        if let latitude = currentLatitude, let longtitude = currentLongtitude {
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            setRegion(center: center, meters: 1200)
        }
    }
}

// MARK: - CLLocation Protocol

extension ParkingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            currentLatitude = coordinate.latitude
            currentLongtitude = coordinate.longitude
            
            setRegion(center: coordinate, meters: 1200)
            setAnnotation(center: coordinate, title: Constant.Annotation.currentLocationTitle)
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

// MARK: - MapView Protocol

extension ParkingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            print(annotationTitle)
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
}

// MARK: - Authorization Method

extension ParkingViewController {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
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
