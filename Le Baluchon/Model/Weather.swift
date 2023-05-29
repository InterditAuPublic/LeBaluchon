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
        print(url)
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



protocol WeatherService {
    func getWeather(city: String, callback: @escaping (Bool, WeatherResponse?) -> Void)
}

class WeatherServiceImplementation: WeatherService {
    
    private let accessKey: String
    private let baseURL: String
    private var city1Weather: WeatherResponse?
    private var city2Weather: WeatherResponse?
    private var task: URLSessionDataTask?
    private var session = URLSession(configuration: .default)
    
    init(session: URLSession = URLSession(configuration: .default)) {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
              let keys = NSDictionary(contentsOfFile: path),
              let accessKey = keys["OpenWeatherApiKey"] as? String,
              let baseURL = keys["OpenWeatherBaseURL"] as? String else {
            fatalError("Unable to read keys from Keys.plist")
        }
        self.accessKey = accessKey
        self.baseURL = baseURL
    }
    
    func getWeather(city: String, callback: @escaping (Bool, WeatherResponse?) -> Void) {
        switch city {
        case "New York":
            if let city1Weather = city1Weather {
                if city1Weather.dt > Int(Date().timeIntervalSince1970) {
                    callback(true, city1Weather)
                } else {
                    getWeatherFromAPI(city: city, callback: callback)
                }
                callback(true, city1Weather)
            } else {
                getWeatherFromAPI(city: city, callback: callback)
            }
        case "Paris":
            if let city2Weather = city2Weather {
                if city2Weather.dt > Int(Date().timeIntervalSince1970) {
                    callback(true, city2Weather)
                } else {
                    getWeatherFromAPI(city: city, callback: callback) // EXC_BAD_ACCESS (code=2, address=0x3086f1db8) when I try to call getWeather(city: city, callback: callback) here
                    
                    
                }
                callback(true, city2Weather)
            } else {
                getWeatherFromAPI(city: city, callback: callback)
            }
        default:
            getWeatherFromAPI(city: city, callback: callback)
        }
    }
    
    func getWeatherFromAPI(city: String, callback: @escaping (Bool, WeatherResponse?) -> Void) {
        guard let url = WeatherRequest(city: city, accessKey: accessKey, baseURL: baseURL).url else {
            callback(false, nil)
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                    callback(false, nil)
                    return
                }
                
                let iconImage = response.weather[0].iconImage
                let sunrise = response.sys.sunriseDate
                let sunset = response.sys.sunsetDate
                
                switch city {
                case "New York":
                    self.city1Weather = response
                case "Paris":
                    self.city2Weather = response
                default:
                    break
                }
                
                callback(true, response)
            }
        }
        task?.resume()
    }
}
