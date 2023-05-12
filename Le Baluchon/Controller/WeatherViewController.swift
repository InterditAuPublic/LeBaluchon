//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController {
    private let model = WeatherModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    func prepareView() {
        titleLabel.text = "Weather"
        // cityTextField.placeholder = "City"
        // getWeatherButton.setTitle("Get Weather", for: .normal)
        // getWeatherButton.setTitleColor(.white, for: .normal)
        // getWeatherButton.backgroundColor = .systemBlue
        // getWeatherButton.layer.cornerRadius = 5
        // getWeatherButton.layer.masksToBounds = true
        // activityIndicator.isHidden = true
    }

    @IBOutlet weak var titleLabel: UILabel!
   
   
    
}
