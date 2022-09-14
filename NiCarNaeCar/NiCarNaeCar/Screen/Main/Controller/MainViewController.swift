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
    
    private lazy var navigationBar = UIView().then {
        $0.addSubviews(logoView, settingButton)
    }
    
    private let logoView = UIImageView().then {
        $0.image = R.Image.imgLogo
        $0.backgroundColor = R.Color.white
        $0.contentMode = .scaleToFill
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(R.Image.btnSetting, for: .normal)
        $0.setTitle("", for: .normal)
        $0.addTarget(self, action: #selector(touchUpSettingButton), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        self.view = rootView
    }
    
    // MARK: - Property
    
    private let locationManager = CLLocationManager()
    private var annotation = MKPointAnnotation()
    
    private var currentLatitude: Double?
    private var currentLongtitude: Double?
    
    private var spotList: [Row] = []
    
    private var currentPage: Int = 1
    private var endPage: Int = 30
    private var totalPage: Int = 0
    
    private var positionId: Int = 0
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserCurrentLocationAuthorization(locationManager.authorizationStatus)
        setLocationManager()
        fetchInitialAnnotation()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        super.configureUI()
        configureMapView()
        registerAnnotationViewClasses()
        configureButton()
    }
    
    override func setLayout() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(48)
        }
        
        logoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(72)
            make.height.equalTo(27)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(9)
            make.width.height.equalTo(Metric.buttonSize)
        }
    }
    
    private func configureMapView() {
        rootView.mapView.delegate = self
    }
    
    private func configureButton() {
        rootView.currentLocationButton.addTarget(self, action: #selector(touchUpLocationButton), for: .touchUpInside)
        rootView.searchButton.addTarget(self, action: #selector(touchUpSearchButton), for: .touchUpInside)
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
    
    private func setSpotListAnnotation() {
        for spot in spotList {
            guard let latitude = Double(spot.la) else { return }
            guard let longtitude = Double(spot.lo) else { return }
            
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            self.setAnnotation(center: center, title: spot.positnNm)
        }
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
    
    private func fetchInitialAnnotation() {
        if currentPage == 1 {
            SpotListAPIManager.requestSpotList(startPage: currentPage, endPage: endPage) { data in
                self.spotList = data.nanumcarSpotList.row
                self.totalPage = data.nanumcarSpotList.listTotalCount
                
                DispatchQueue.main.async {
                    self.setSpotListAnnotation()
                }
            }
        }
    }
    
    // MARK: - @objc
    
    @objc func touchUpLocationButton() {
        if let latitude = currentLatitude, let longtitude = currentLongtitude {
            let currentLocation = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), latitudinalMeters: 1200, longitudinalMeters: 1200)
            rootView.mapView.setRegion(currentLocation, animated: true)
        }
    }
    
    @objc func touchUpSettingButton() {
        let viewController = SettingViewController()
        transition(viewController, transitionStyle: .push)
    }
    
    @objc func touchUpSearchButton() {
        currentPage += 30
        endPage += 30
        
        if endPage <= totalPage {
            SpotListAPIManager.requestSpotList(startPage: currentPage, endPage: endPage) { list in
                dump(list)
                
                DispatchQueue.main.async {
                    if let latitude = self.currentLatitude, let longtitude = self.currentLongtitude {
                        let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude),
                                                            latitudinalMeters: CLLocationDistance(2000 + self.currentPage * 80),
                                                            longitudinalMeters: CLLocationDistance(2000 + self.currentPage * 80))
                        self.rootView.mapView.setRegion(viewRegion, animated: false)
                    }
                    
                    
                    for spot in list.nanumcarSpotList.row {
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
}

// MARK: - MapView Protocol

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            guard let title = annotationTitle else { return }
            for spot in spotList {
                if spot.positnNm == title {
                    print("거점 ID: ", spot.positnCD)
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
        if annotation.title == "나의 현재 위치" {
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = .systemRed
            return annotationView
        } else {
            let annotationView = DefaultAnnoationView(annotation: annotation, reuseIdentifier: DefaultAnnoationView.ReuseID)
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else {
            print("Faild To Draw")
            return MKOverlayRenderer()
        }
        
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
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
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
            currentLatitude = coordinate.latitude
            currentLongtitude = coordinate.longitude
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
