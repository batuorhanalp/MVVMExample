//
//  AlamofireExtension.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Alamofire

public enum ConnectionType {
    case noConnection
    case wifiConnection
    case gsmConnection
}

public enum ResponseError: Error {
    case network(error: Error)
    case dataSerialization(reason: String)
    case jsonSerialization(error: Error)
    case objectSerialization(reason: String)
    case xmlSerialization(error: Error)
}

public protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: AnyObject)
}

public protocol ResponseCollectionSerializable {
    static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    
    public static func object(response: HTTPURLResponse, representation: AnyObject) -> Self? {
        if let representationObject = representation as? [String: AnyObject] {
            if let item = Self(response: response, representation: representationObject as AnyObject) {
                return item
            }
        }
        
        return nil
    }
    
    public static func collection(response: HTTPURLResponse, representation: AnyObject) -> [Self] {
        var collection = [Self]()
        
        if let representation = representation as? [[String: AnyObject]] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation as AnyObject) {
                    collection.append(item)
                }
            }
        }
        
        return collection
    }
}

extension Alamofire.DataRequest {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: @escaping(DataResponse<T>) -> Void) -> Self {
        
        let responseSerializer = DataResponseSerializer<T> { response in
            
            guard response.3 == nil else {
                return .failure(ResponseError.network(error: response.3!))
            }
            
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(response.0, response.1, response.2, response.3)
            
            switch result {
            case .success(let value):
                if let response = response.1, let responseObject = T(response: response, representation: value as AnyObject)
                {
                    return .success(responseObject)
                } else {
                    return .failure(ResponseError.objectSerialization(reason: "JSON could not be serialized into response object: \(value)"))
                }
            case .failure(let error):
                return .failure(ResponseError.jsonSerialization(error: error))
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: @escaping(DataResponse<[T]>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<[T]> { response in
            
            guard response.3 != nil else {
                return .failure(ResponseError.network(error: response.3!))
            }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(response.0, response.1, response.2, response.3)
            
            switch result {
            case .success(let value):
                if let response = response.1 {
                    return .success(T.collection(response: response, representation: value as AnyObject))
                } else {
                    return .failure(ResponseError.objectSerialization(reason: "Response collection could not be serialized due to nil response"))
                }
            case .failure(let error):
                return .failure(ResponseError.jsonSerialization(error: error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

