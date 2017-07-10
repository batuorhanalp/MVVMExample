//
//  Dynamic.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

class Dynamic<T> {
    
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
}
