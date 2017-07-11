//
//  ViewController.swift
//  WeatherMVVMExample
//
//  Created by Batu Orhanalp on 07/07/2017.
//  Copyright © 2017 Batu Orhanalp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityField: UITextField!

    var weatherViewModel = WeatherViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        cityField.rx.text.orEmpty.bind(to: weatherViewModel.city).disposed(by: disposeBag)
        
        weatherViewModel.data
            .bind(to: tableView.rx.items(cellIdentifier: R.reuseIdentifier.weatherCell.identifier, cellType: WeatherTableViewCell.self))
            { (row, element, cell) in
                cell.descriptionLabel.text = element.currentDescription
            }
            .disposed(by: disposeBag)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

