//
//  Weather.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Foundation

final class Weather: NSObject, ResponseObjectSerializable, ResponseCollectionSerializable {
    
    var currentDescription: String = ""
    var currentTemperature: Float = 0
    var date: Date = Date()
    var icon: String = ""
    var maxTemperature: Float = 0
    var minTemperature: Float = 0
    
    override init() {
        super.init()
    }
    
    convenience required init(response: HTTPURLResponse, representation: AnyObject) {
        
        self.init()
        
        // Weather descriptions
        let weatherDatas = representation.value(forKeyPath: "weather") as! NSArray
        let weatherData = weatherDatas[0] as AnyObject
        
        // Temperatures
        let main = representation.value(forKeyPath: "main") as AnyObject
                
        let date = representation.value(forKeyPath: "dt_txt") as! String
        
        self.date = date.toDate() ?? Date()
        self.currentTemperature = main.value(forKeyPath: "temp") as! Float
        self.currentDescription = weatherData.value(forKeyPath: "description") as! String
        self.icon = weatherData.value(forKeyPath: "icon") as! String
        self.maxTemperature = main.value(forKeyPath: "temp_max") as! Float
        self.minTemperature = main.value(forKeyPath: "temp_min") as! Float
    }
    
    init(description: String, currentTemperature: Float, date: Date, icon: String, maxTemperature: Float, minTemperature: Float) {
        
        self.currentDescription = description
        self.currentTemperature = currentTemperature
        self.date = date
        self.icon = icon
        self.maxTemperature = maxTemperature
        self.minTemperature = minTemperature
        
    }
}
