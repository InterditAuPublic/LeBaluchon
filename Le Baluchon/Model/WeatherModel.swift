//
//  Weather.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 11/05/2023.
//

import Foundation
import UIKit

struct WeatherResponse: Codable {
    let coord: Coord
    var weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    var iconImage: UIImage? {
        guard let weatherIcon = WeatherIcon(rawValue: icon) else {
            return nil
        }
        return weatherIcon.getIconImage()
    }
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Clouds: Codable {
    let all: Int
}

struct Sys: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
    var sunriseDate: String {
        let date = Date(timeIntervalSince1970: Double(sunrise))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
    var sunsetDate: String {
        let date = Date(timeIntervalSince1970: Double(sunset))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

struct WeatherError: Codable {
    let cod: String
    let message: String
}

struct WeatherRequest {
    let city: String
    let accessKey: String
    let baseURL: String
    
    var url: URL? {
        guard let url = URL(string: baseURL) else {
            return nil
        }
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: accessKey),
            URLQueryItem(name: "units", value: "metric")
        ]
        return urlComponents?.url
    }
}

enum WeatherIcon: String {
    case clearDay = "01d"
    case clearNight = "01n"
    case fewCloudyDay = "02d"
    case fewCloudyNight = "02n"
    case cloudyDay = "03d"
    case cloudyNight = "03n"
    case brokenCloudDay = "04d"
    case brokenCloudNight = "04n"
    case rainDay = "09d"
    case rainNight = "09n"
    case lightRainDay = "10d"
    case lightRainNight = "10n"
    case thunderDay = "11d"
    case thunderNight = "11n"
    case snowDay = "13d"
    case snowNight = "13n"
    case mistDay = "50d"
    case mistNight = "50n"
    
    func getIconImage() -> UIImage {
        switch self {
        case .clearDay:
            return UIImage(systemName: "sun.max")!
        case .clearNight:
            return UIImage(systemName: "moon.stars")!
        case .fewCloudyDay:
            return UIImage(systemName: "cloud.sun")!
        case .fewCloudyNight:
            return UIImage(systemName: "cloud.moon")!
        case .cloudyDay, .cloudyNight:
            return UIImage(systemName: "cloud")!
        case .brokenCloudDay, .brokenCloudNight:
            return UIImage(systemName: "cloud.fog")!
        case .rainDay:
            return UIImage(systemName: "cloud.rain")!
        case .rainNight:
            return UIImage(systemName: "cloud.rain.fill")!
        case .lightRainDay:
            return UIImage(systemName: "cloud.sun.rain")!
        case .lightRainNight:
            return UIImage(systemName: "cloud.moon.rain")!
        case .thunderDay:
            return UIImage(systemName: "cloud.sun.bolt")!
        case .thunderNight:
            return UIImage(systemName: "cloud.moon.bolt")!
        case .snowDay:
            return UIImage(systemName: "cloud.snow")!
        case .snowNight:
            return UIImage(systemName: "cloud.snow.fill")!
        case .mistDay, .mistNight:
            return UIImage(systemName: "cloud.fog")!
        }
    }
}
