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
    
    @IBOutlet weak var infoHorizontalStackView: UIStackView!
    
    @IBOutlet weak var sunriseVerticalStackView: UIStackView!
    
    @IBOutlet weak var windSpeedVerticalStackView: UIStackView!
    
    @IBOutlet weak var sunsetVerticalStackView: UIStackView!
    private let weatherService = WeatherServiceImplementation()
    private var city: String
    private weak var vc : WeatherViewController?
    
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
//                UIAlertHelper.showAlertWithTitle("Error", message: "Unable to get weather for \(city)", from: self!.vc!)
                return
            }
            DispatchQueue.main.async {
                self.updateView(weather: weatherResponse)
            }
        }
    }
    
    func updateView(weather: WeatherResponse) {
        cityLabel.text = weather.name
        tempLabel.text = "\(formatTemp(temp: weather.main.temp))°C"
        descriptionLabel.text = weather.weather.first?.description
        // sunriseLabel.text = weather.sys.sunrise
        // sunsetLabel.text = weather.sys.sunset
        sunriseLabel.text = convertUnixTimestampToTime(unixTimestamp: weather.sys.sunrise, timezone: weather.timezone)
        sunsetLabel.text = convertUnixTimestampToTime(unixTimestamp: weather.sys.sunset, timezone: weather.timezone)

        windLabel.text = "\(weather.wind.speed) km/h"
        weatherIcon.image = weather.weather.first?.iconImage
        sunriseIcon.image = UIImage(systemName: "sunrise")
        sunsetIcon.image = UIImage(systemName: "sunset")
        windIcon.image = UIImage(systemName: "wind.circle")
    }

    // convert unix timestamp to time string for sunrise and sunset labels (HH:mm) that takes into account the timezone
    private func convertUnixTimestampToTime(unixTimestamp: Int, timezone: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }

    // format temperature to 1 decimal
    private func formatTemp(temp: Double) -> String {
        return String(format: "%.1f", temp)
    }
    
    
}
