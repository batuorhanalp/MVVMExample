//
//  WeatherViewModel.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Foundation

class WeatherViewModel: NSObject {
    
    fileprivate let weather: Weather
    
    init(weather: Weather) {
        
        self.weather = weather
        
    }
    
}
