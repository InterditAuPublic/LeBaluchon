//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 08/06/2023.
//

import Foundation

protocol WeatherService {
    func getWeather(city: String, callback: @escaping (Bool, WeatherResponse?) -> Void)
}

class WeatherServiceImplementation: WeatherService {
    
    private let accessKey: String
    private let baseURL: String
    private var cityWeathers: [String: WeatherResponse] = [:]
    private var task: URLSessionDataTask?
    public let session = URLSession(configuration: .default)
    
    init() {
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
        if let cachedWeather = cityWeathers[city], cachedWeather.dt > Int(Date().timeIntervalSince1970) {
            callback(true, cachedWeather)
        } else {
            getWeatherFromAPI(city: city, callback: callback)
        }
    }
    
    func getWeatherFromAPI(city: String, callback: @escaping (Bool, WeatherResponse?) -> Void) {
        guard let url = WeatherRequest(city: city, accessKey: accessKey, baseURL: baseURL).url else {
            callback(false, nil)
            return
        }
        task?.cancel()
        task = session.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = try? JSONDecoder().decode(WeatherResponse.self, from: data) else {
                    callback(false, nil)
                    return
                }
                self?.cityWeathers[city] = response
                callback(true, response)
            }
        }
        task?.resume()
    }
}
