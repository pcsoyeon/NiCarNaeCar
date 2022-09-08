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

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - UI Method
    
    override func configureUI() {
        super.configureUI()
    }
    
    override func setLayout() {
        
    }
    
    private func configureMapView() {
        rootView.mapView.delegate = self
    }
}

// MARK: - MapView Protocol

extension MainViewController: MKMapViewDelegate {
    
}
