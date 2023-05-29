//
//  CityWeatherView.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 29/05/2023.
//

import Foundation
import UIKit

class CityWeatherReusableView: UIView {
    
    @IBOutlet var cityReusableView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunriseIcon: UIImageView!
    @IBOutlet weak var sunsetIcon: UIImageView!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var windLabel: UILabel!
    
    private let weatherService = WeatherServiceImplementation()
    private var city: String
    
    init(city: String) {
        self.city = city
        super.init(frame: .zero)
        commonInit()
        getCityWeather(city: city)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.city = ""
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed("CityWeatherReusableView", owner: self, options: nil)
        addSubview(cityReusableView)
        cityReusableView.frame = bounds
        cityReusableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func getCityWeather(city: String) {
        weatherService.getWeather(city: city) { [weak self] success, weatherResponse in
            guard let self = self, success, let weatherResponse = weatherResponse else {
                print("ERROR WHILE GETTING DATA")
                return
            }
            DispatchQueue.main.async {
                self.updateView(weather: weatherResponse)
            }
        }
    }
    
    func updateView(weather: WeatherResponse) {
        cityLabel.text = weather.name
        tempLabel.text = "\(weather.main.temp)°C"
        descriptionLabel.text = weather.weather.first?.description
        sunriseLabel.text = weather.sys.sunriseDate
        sunsetLabel.text = weather.sys.sunsetDate
        windLabel.text = "\(weather.wind.speed) km/h"
        weatherIcon.image = weather.weather.first?.iconImage
        sunriseIcon.image = UIImage(systemName: "sunrise")
        sunsetIcon.image = UIImage(systemName: "sunset")
        windIcon.image = UIImage(systemName: "wind")
    }
}
