//
//  StringExtension.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        if let date = dateFormatter.date(from: self) { return date }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S"
        if let date = dateFormatter.date(from: self) { return date }
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.S"
        if let date = dateFormatter.date(from: self) { return date }
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: self) { return date }
        
        return nil
    }
}
