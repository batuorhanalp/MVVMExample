//
//  ForeCastService.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire

struct ForecastService {
    
    private static let rootPath = "forecast"
    
    static func get(dayCount: Int, cityId: String?) -> Observable<[Weather]> {
        
        var parameters = [String : AnyObject]()
        
        if let city = cityId {
            parameters = ["id" : city,
                          "units" : "metric",
                          "cnt" : dayCount,
                          "lang" : "tr"] as [String : AnyObject]
        } else {
            // TODO get location
        }
        
        let router = Router(method: .get, path: ForecastService.rootPath, parameters: parameters)
        do {
            let request = try router.asURLRequest()
            return RxAlamofire.requestJSON(request)
                .debug()
                .map({ (response, json) -> [Weather] in
                    guard let forecastResponse = ForecastResponse(response: response, representation: json as AnyObject) else {
                        return [Weather]()
                    }
                    return  forecastResponse.weathers
                })
        } catch let error {
            print("An error occured while fetching weather from API. Error details:\n\(error)")
            return Observable.just([])
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
        _ = representation.value(forKeyPath: "city") as AnyObject
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
                _ = weatherObject.value(forKeyPath: "wind") as AnyObject
                // TODO wind
            }
        }
    }
}

