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

import RxSwift
import RxCocoa

final class ParkingViewController: BaseViewController {
    
    // MARK: - UI Property
    
    private let rootView = ParkingMapView()
    
    private lazy var navigationBar = NDSNavigationBar(self).then {
        $0.title = "주차장"
        $0.backButtonIsHidden = true
        $0.closeButtonIsHidden = true
    }
    
    private lazy var searchButton = UIButton().then {
        $0.setImage(R.Image.btnSearch, for: .normal)
        $0.setTitle("", for: .normal)
        $0.addTarget(self, action: #selector(touchUpSearchButton), for: .touchUpInside)
    }
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var annotation = MKPointAnnotation()
    
    private var currentLatitude: Double?
    private var currentLongtitude: Double?
    
    private var selectedLocality: String = ""
    
    private var parkinglist: [ParkingDetailInfo] = []
    
    private var disposeBag = DisposeBag()
    
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
        bind()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        super.configureUI()
        configureMapView()
    }
    
    override func setLayout() {
        view.addSubview(navigationBar)
        navigationBar.addSubview(searchButton)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.navigationButtonTrailing)
            make.width.height.equalTo(Metric.navigationButtonSize)
        }
    }
    
    private func configureNavigation() {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureMapView() {
        rootView.mapView.delegate = self
        rootView.mapView.showsCompass = false
        
        rootView.mapView.register(DefaultAnnoationView.self, forAnnotationViewWithReuseIdentifier: DefaultAnnoationView.ReuseID)
    }
    
    private func bind() {
        rootView.currentLocationButton.rx.tap
            .debounce(.microseconds(10), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .bind { vc, _ in
                if let latitude = vc.currentLatitude, let longtitude = vc.currentLongtitude {
                    let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    vc.setRegion(center: center, meters: 1200)
                }
            }
            .disposed(by: disposeBag)
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
    
    private func removeAnnotations() {
        rootView.mapView.annotations.forEach {
            if !($0.title == Constant.Annotation.currentLocationTitle) {
              self.rootView.mapView.removeAnnotation($0)
          }
        }
    }
    
    private func fetchParkingListWithRegion(_ region: String) {
        ParkingAPIManager.requestParkingList(startPage: 1, endPage: 1000, region: region) { data, error in
            guard let data = data else { return }
            
            self.parkinglist = data.getParkInfo.row
            
            DispatchQueue.main.async {
                for parkinglot in data.getParkInfo.row {
                    let center = CLLocationCoordinate2D(latitude: parkinglot.lat, longitude: parkinglot.lng)
                    self.setAnnotation(center: center, title: parkinglot.parkingName)
                }
            }
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpSearchButton() {
        let viewController = MainSearchViewController()
        viewController.locationClosure = { locality in
            self.selectedLocality = locality
            
            for locality in LocalityType.allCases {
                if self.selectedLocality == locality.rawValue {
                    let center = locality.location
                    self.setRegion(center: center, meters: 8000)
                }
            }
            
            self.selectedLocality = String(locality.dropLast(1))
            self.removeAnnotations()
            
            self.fetchParkingListWithRegion(self.selectedLocality)
        }
        transition(viewController, transitionStyle: .push)
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
            if annotationTitle != Constant.Annotation.currentLocationTitle {
                for item in parkinglist {
                    if item.parkingName == annotationTitle {
                        let viewController = ParkingDetailViewController()
                        viewController.paringDetailInfo = item
                        transition(viewController, transitionStyle: .presentFullScreen)
                        break
                    }
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
