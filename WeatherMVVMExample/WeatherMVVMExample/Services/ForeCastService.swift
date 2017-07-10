//
//  ForeCastService.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Foundation
import Alamofire

struct ForecastService {
    
    private static let rootPath = "forecast"
    
    static func get(dayCount: Int, cityId: Int?, completion: @escaping (_ response: ForecastResponse?) -> ()) {
        
        var parameters = [String : AnyObject]()
        
        if let city = cityId {
            parameters = ["id" : city as AnyObject ,
                          "units" : "metric" as AnyObject,
                          "cnt" : dayCount as AnyObject,
                          "lang" : "tr" as AnyObject]
        } else {
            // TODO get location
        }
        
        let router = Router(method: .get, path: ForecastService.rootPath, parameters: parameters)
        do {
            let request = try router.asURLRequest()
            _ = Alamofire.request(request)
                .responseObject(completionHandler: { (response: DataResponse<ForecastResponse>) in
                    
                    print("Weather response: \(response)")
                    
                    if let value = response.result.value {
                        completion(value)
                    } else {
                        completion(nil)
                    }
                })
        } catch let error {
            print("An error occured while fetching weather from API. Error details:\n\(error)")
            completion(nil)
        }
    }
    
}

/*
 * Weather response serialize
 */
struct ForecastResponse: ResponseObjectSerializable, ResponseCollectionSerializable {
    
    // TODO add city
    var weathers = [Weather]()
    // TODO add wind
    
    init?(response: HTTPURLResponse, representation: AnyObject) {
        
        // City info
        let city = representation.value(forKeyPath: "city") as AnyObject
        // TODO city
        
        if let weatherObjects = representation.value(forKeyPath: "list") as? NSArray {
            // First get each weather item
            for case let weatherObject as AnyObject in weatherObjects {
                
                // Create weather entity
                let newWeather = Weather(response: response, representation: weatherObject)
                
                // Adding to return array
                weathers.append(newWeather)
                
                
                /*
                 * Wind data
                 */
                // Wind
                let wind = weatherObject.value(forKeyPath: "wind") as AnyObject
                // TODO wind
            }
        }
    }
}

