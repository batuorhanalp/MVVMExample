//
//  WeatherViewModel.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 10/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct WeatherViewModel {
    
    //fileprivate let weather: Weather
        
    let city = Variable("")
    let disposeBag = DisposeBag()
    
    lazy var data: Observable<[Weather]> = {
        return self.city.asObservable()
            .throttle(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest {
                ForecastService.get(dayCount: 7, cityId: $0)
            }
    }()
    
    
}
