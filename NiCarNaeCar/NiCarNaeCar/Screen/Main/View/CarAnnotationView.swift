//
//  CarAnnotationView.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import MapKit

import NiCarNaeCar_Resource

class DefaultAnnoationView: MKMarkerAnnotationView {
    
    static let ReuseID = "defaultAnnotation"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "default"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultHigh
        markerTintColor = R.Color.black200
    }
}
