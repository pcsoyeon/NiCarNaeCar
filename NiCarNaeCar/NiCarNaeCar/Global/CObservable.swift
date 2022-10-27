//
//  Observable.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/15.
//

import Foundation

class CObservable<T> {
    
    private var listener: ((T) -> ())?
    
    var value: T {
        didSet {
            print("didSet", value)
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> ()) {
        print("Observable Bind")
        closure(value)
        listener = closure
    }
}
