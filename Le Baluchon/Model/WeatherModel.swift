//
//  Weather.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 11/05/2023.
//

import Foundation

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
    let error: WeatherError?
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

struct WeatherError: Codable {
    let cod: String
    let message: String
}

enum WeatherServiceError: Error {
    case invalidURL
    case noData
    case networkError(Error)
    case decodingError(Error)
    case apiError(WeatherError)
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No Data Returned"
        case .networkError(let error):
            return "Network Error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding Error: \(error.localizedDescription)"
        case .apiError(let weatherError):
            return "API Error: \(weatherError.message)"
        }
    }
}
