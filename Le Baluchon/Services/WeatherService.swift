//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 08/06/2023.
//

import Foundation

protocol WeatherService {
func getWeather(city: String, completion: @escaping (Result<WeatherResponse, WeatherServiceError>) -> Void)
}

class WeatherServiceImplementation: WeatherService {

private let accessKey: String
private let baseURL: String
var cityWeathers: [String: WeatherResponse] = [:]
var task: (any URLSessionDataTaskProtocol)?
let urlSession: any URLSessionProtocol

init(urlSession: any URLSessionProtocol = URLSession(configuration: .default)) {
    self.urlSession = urlSession
    let path = Bundle.main.path(forResource: "Keys", ofType: "plist")!
    let keys = NSDictionary(contentsOfFile: path)
    let accessKey = keys!["OpenWeatherApiKey"] as? String
    let baseURL = keys!["OpenWeatherBaseURL"] as? String
    self.accessKey = accessKey!
    self.baseURL = baseURL!
}

func getWeather(city: String, completion: @escaping (Result<WeatherResponse, WeatherServiceError>) -> Void) {
    if let cachedWeather = cityWeathers[city], cachedWeather.dt > Int(Date().timeIntervalSince1970) {
        completion(.success(cachedWeather))
    } else {
        getWeatherFromAPI(city: city, completion: completion)
    }
}

func getWeatherFromAPI(city: String, completion: @escaping (Result<WeatherResponse, WeatherServiceError>) -> Void) {
    let url = WeatherRequest(city: city, accessKey: accessKey, baseURL: baseURL).url!
    task?.cancel()
    let urlRequest = URLRequest(url: url)
    task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
        DispatchQueue.main.async {
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            do {
                if let errorResponse = try? JSONDecoder().decode(WeatherError.self, from: data) {
                    completion(.failure(.apiError(errorResponse.message)))
                        return
                    }
                    let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    completion(.success(weatherResponse))
                    self.cityWeathers[city] = weatherResponse
                } catch let decodingError {
                    completion(.failure(.decodingError(decodingError)))
            }
        }
    }
    task?.resume()
}


}
