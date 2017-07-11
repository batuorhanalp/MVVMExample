//
//  Router.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Alamofire
import Reachability

struct Router: URLRequestConvertible {
    
    // Api base URL address
    static let url = "http://api.openweathermap.org"
    // Api route
    static private let baseUrlString = "\(url)/data/2.5/"
    // Api app id
    private let appId = "83a486229a2d0ba27eec7b79bc6defde"
    var path: String!
    var parameters: Parameters?
    var method: Alamofire.HTTPMethod!
    
    static var checkConnection: NetworkStatus {
        if let reachable = Reachability.init(hostName: Router.baseUrlString) {
            return reachable.currentReachabilityStatus()
        }
        
        return .NotReachable
    }
    
    init(method: Alamofire.HTTPMethod, path: String, parameters: Parameters?) {
        self.method = method
        self.parameters = parameters
        self.parameters?["appId"] = self.appId
        self.path = path
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = URL(string: Router.baseUrlString)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if self.method == Alamofire.HTTPMethod.post {
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: self.parameters!)
        } else if self.method == Alamofire.HTTPMethod.put {
            return try Alamofire.JSONEncoding.default.encode(urlRequest, with: self.parameters)
        } else {
            return try Alamofire.URLEncoding.default.encode(urlRequest, with: self.parameters)
        }
    }
}

