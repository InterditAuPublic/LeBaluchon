//
//  CityWeatherView.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 29/05/2023.
//

import Foundation
import UIKit

class CityWeatherReusableView: UIView {

// MARK: - Outlets

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

// MARK: - Properties

private let weatherService = WeatherServiceImplementation()
private var city: String
private weak var vc : WeatherViewController?
private let activityIndicator: UIActivityIndicatorView = {
let indicator = UIActivityIndicatorView(style: .large)
indicator.hidesWhenStopped = true
return indicator
}()


// MARK: - Init

init(city: String) {
    self.city = city
    super.init(frame: .zero)
    commonInit()
    prepareView()
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

func prepareView() {
    cityLabel.text = city
    cityLabel.font = UIFont.boldSystemFont(ofSize: 30)
    cityLabel.textColor = .white
    tempLabel.font = UIFont.boldSystemFont(ofSize: 30)
    tempLabel.textColor = .white
    descriptionLabel.font = UIFont.boldSystemFont(ofSize: 20)
    descriptionLabel.textColor = .white
    sunriseLabel.font = UIFont.boldSystemFont(ofSize: 20)
    sunriseLabel.textColor = .white
    sunsetLabel.font = UIFont.boldSystemFont(ofSize: 20)
    sunsetLabel.textColor = .white
    windLabel.font = UIFont.boldSystemFont(ofSize: 20)
    windLabel.textColor = .white
    sunriseIcon.tintColor = .white
    sunsetIcon.tintColor = .white
    windIcon.tintColor = .white
    weatherIcon.tintColor = .white
    infoHorizontalStackView.spacing = 20
    sunriseVerticalStackView.spacing = 10
    sunsetVerticalStackView.spacing = 10
    windSpeedVerticalStackView.spacing = 10
    // aling the stack views to the center of the view and set the spacing between them
    infoHorizontalStackView.alignment = .center
    infoHorizontalStackView.distribution = .equalSpacing
    sunriseVerticalStackView.alignment = .center
    sunriseVerticalStackView.distribution = .equalSpacing
    sunsetVerticalStackView.alignment = .center
    sunsetVerticalStackView.distribution = .equalSpacing
    windSpeedVerticalStackView.alignment = .center
    windSpeedVerticalStackView.distribution = .equalSpacing

        cityReusableView.addSubview(activityIndicator)
activityIndicator.translatesAutoresizingMaskIntoConstraints = false
activityIndicator.centerXAnchor.constraint(equalTo: cityReusableView.centerXAnchor).isActive = true
activityIndicator.centerYAnchor.constraint(equalTo: cityReusableView.centerYAnchor).isActive = true
    
    // place infoHorizontalStackView under the descriptionLabel and set the spacing between them, align the stack view to the center of the view
    cityReusableView.addSubview(infoHorizontalStackView)
    infoHorizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    infoHorizontalStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
    infoHorizontalStackView.leadingAnchor.constraint(equalTo: cityReusableView.leadingAnchor, constant: 20).isActive = true
    infoHorizontalStackView.trailingAnchor.constraint(equalTo: cityReusableView.trailingAnchor, constant: -20).isActive = true
    infoHorizontalStackView.bottomAnchor.constraint(equalTo: cityReusableView.bottomAnchor, constant: -20).isActive = true

}

// MARK: - Methods

private func getCityWeather(city: String) {
activityIndicator.startAnimating()

weatherService.getWeather(city: city) { [weak self] result in
    DispatchQueue.main.async {
        self?.activityIndicator.stopAnimating()

        guard let self = self else { return }

        switch result {
        case .success(let weatherResponse):
            self.updateView(weather: weatherResponse)
        case .failure(_):
            if let vc = self.vc {
                UIAlertHelper.showAlertWithTitle("Oups!", message: "Sorry, something went wrong. Please try again later.", from: vc)
            }
        }
    }
}
}


// private func getCityWeather(city: String) {
//     activityIndicator.startAnimating()
//     let deadlineTime = DispatchTime.now() + .seconds(10)

//     weatherService.getWeather(city: city) { [weak self] result in
//         DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
//             self?.activityIndicator.stopAnimating()
        
//             guard let self = self else { return }
        
//             switch result {
//             case .success(let weatherResponse):
//                 DispatchQueue.main.async {
//                     self.updateView(weather: weatherResponse)
//                 }
//             case .failure(_):
//                 DispatchQueue.main.async {
//                     if let vc = self.vc {
//                         UIAlertHelper.showAlertWithTitle("Oups!", message: "Sorry, something went wrong. Please try again later.", from: vc)
//                     }
//                 }
//             }
//         }
//     }
// }


func updateView(weather: WeatherResponse) {
    cityLabel.text = weather.name
    tempLabel.text = "\(formatTemp(temp: weather.main.temp))°C"
    descriptionLabel.text = weather.weather.first?.description
    sunriseLabel.text = convertUnixTimestampToTime(unixTimestamp: weather.sys.sunrise, timezone: weather.timezone)
    sunsetLabel.text = convertUnixTimestampToTime(unixTimestamp: weather.sys.sunset, timezone: weather.timezone)
    windLabel.text = "\(weather.wind.speed) km/h"
    weatherIcon.image = getNativeIcon(icon: weather.weather.first?.icon ?? "02n")
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

// get native icon from icon code provided by the API
private func getNativeIcon(icon: String) -> UIImage? {
    switch icon {
    case "01d":
        return UIImage(systemName: "sun.max")
    case "01n":
        return UIImage(systemName: "moon.stars")
    case "02d":
        return UIImage(systemName: "cloud.sun")
    case "02n":
        return UIImage(systemName: "cloud.moon")
    case "03d", "03n", "04d", "04n":
        return UIImage(systemName: "cloud")
    case "09d", "09n":
        return UIImage(systemName: "cloud.rain")
    case "10d":
        return UIImage(systemName: "cloud.sun.rain")
    case "10n":
        return UIImage(systemName: "cloud.moon.rain")
    case "11d", "11n":
        return UIImage(systemName: "cloud.sun.bolt")
    case "13d":
        return UIImage(systemName: "cloud.snow")
    case "13n":
        return UIImage(systemName: "cloud.snow.fill")
    case "50d", "50n":
        return UIImage(systemName: "cloud.fog")
    default:
        return nil
    }
}
}
