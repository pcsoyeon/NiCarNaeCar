//
//  DummyLocationData.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/08.
//

import Foundation

struct Car {
    let location: String
    let latitude: Double
    let longitude: Double
}

struct CarList {
    var mapAnnotations: [Car] = [
        Car(location: "자동차 위치1", latitude: 37.4824761978647, longitude: 126.9521680487202),
        Car(location: "자동차 위치2", latitude: 37.47947929602294, longitude: 126.88891083192269),
        Car(location: "자동차 위치3", latitude: 37.48581351541419, longitude:  126.98092132899579),
        Car(location: "자동차 위치4", latitude: 37.49948523972615, longitude: 127.02570417165666),
        Car(location: "자동차 위치5", latitude: 37.52666023337906, longitude: 126.9258351013706),
        Car(location: "자동차 위치6", latitude: 37.53149302830903, longitude: 126.9654030486416)
    ]
}
