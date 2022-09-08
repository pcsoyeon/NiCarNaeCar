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

final class MainViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = MainView()
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var annotation = MKPointAnnotation()
    
    // TODO: REMOVE
    private var carList = CarList().mapAnnotations
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
        setRegionAndAnnotation(title: "청년취업사관학교 영등포 캠퍼스")
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        super.configureUI()
        configureMapView()
        registerAnnotationViewClasses()
        
    }
    
    override func setLayout() {
        
    }
    
    private func configureMapView() {
        rootView.mapView.delegate = self
        
        for car in carList {
            let center = CLLocationCoordinate2D(latitude: car.latitude, longitude: car.longitude)
            self.setAnnotation(center: center, title: car.location)
        }
    }
    
    // MARK: - Custom Method
    
    private func setLocationManager() {
        locationManager.delegate = self
    }
    
    private func setRegionAndAnnotation(center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270),title: String) {
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1200, longitudinalMeters: 1200)
        
        rootView.mapView.setRegion(region, animated: true)
        setAnnotation(center: center, title: title)
    }
    
    func setAnnotation(center: CLLocationCoordinate2D, title: String) {
        let annotation =  MKPointAnnotation()
        
        annotation.coordinate = center
        annotation.title = title
        
        rootView.mapView.addAnnotation(annotation)
    }
    
    private func registerAnnotationViewClasses() {
        rootView.mapView.register(DefaultAnnoationView.self, forAnnotationViewWithReuseIdentifier: DefaultAnnoationView.ReuseID)
    }
}

// MARK: - MapView Protocol

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            guard let title = annotationTitle else { return }
            print("============================== \(title) ==============================")
            
            transition(MainSheetViewController(), transitionStyle: .present)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.title == "나의 현재 위치" {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = .systemRed
            return annotationView
        } else {
            let annotationView = DefaultAnnoationView(annotation: annotation, reuseIdentifier: DefaultAnnoationView.ReuseID)
            return annotationView
        }
    }
}

// MARK: - Authorization Method

extension MainViewController {
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어 위치 권한 요청을 하지 못합니다.")
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
            setRegionAndAnnotation(center: coordinate, title: "나의 현재 위치")
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
