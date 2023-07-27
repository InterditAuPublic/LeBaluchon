//
//  WeatherTests.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 09/06/2023.
//

import XCTest
@testable import Le_Baluchon    

final class WeatherTests: XCTestCase {

    func mockRequestReturnData() throws -> WeatherResponse {
        let weatherData = WeatherResponse.init(coord: Coord.init(lon: 2.3488, lat: 48.8534), weather: [Weather.init(id: 800, main: "Clear", description: "clear sky", icon: "01d")], base: "stations", main: Main.init(temp: 293.15, feels_like: 292.15, temp_min: 292.15, temp_max: 294.15, pressure: 1018, humidity: 72), visibility: 10000, wind: Wind.init(speed: 1.54, deg: 0), clouds: Clouds.init(all: 0), dt: 1623234050, sys: Sys.init(type: 2, id: 2019646, country: "FR", sunrise: 1623183180, sunset: 1623239990), timezone: 7200, id: 2988507, name: "Paris", cod: 200)
        return weatherData
    }
    
    func mockRequestReturnNotFound() {
        let weatherError = WeatherError(cod: "404", message: "Error")
        XCTAssert(weatherError.cod == "404")
        XCTAssertEqual(weatherError.cod, "404")
    }
    
    func retrieveParisWeatherSucceed() {
        //        let WeatherResponse = try mockRequestReturnData()
        //        print(WeatherResponse)
        //
        //        XCTAssertThrowsError(WeatherResponse.name == "Paris")
    }
    
    func test_getWeatherFromAPI_shouldCallbackFalseNil_whenCallbackErrorNonNil() {
        // Given
        let weatherService = WeatherServiceImplementation()
        //        let error = Error()
//        weatherService.session = MockSession(data: , response: , error: error)
        let city = "Paris"
        let expectation = expectation(description: "TextMatching")
        
        // When
        weatherService.getWeatherFromAPI(city: city, callback: { (success, response) in
            
            // Then
            XCTAssertFalse(success)
            XCTAssertNil(response)
            
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testIconImageWithValidIcon() {
        let weather = Weather(id: 1, main: "Sunny", description: "Clear sky", icon: "01d")
        
        XCTAssertNotNil(weather.iconImage)
    }
    
    func testIconImageWithInvalidIcon() {
        let weather = Weather(id: 2, main: "Cloudy", description: "Partly cloudy", icon: "invalid_icon")
        
        XCTAssertNil(weather.iconImage)
    }

    func testSunriseDateConversion() {
        let sys = Sys(type: 1, id: 123, country: "US", sunrise: 1625865600, sunset: 1625911142)
        
        XCTAssertEqual(sys.sunriseDate, "5:20 AM")
    }
    
    func testSunsetDateConversion() {
        let sys = Sys(type: 2, id: 456, country: "UK", sunrise: 1625865600, sunset: 1625911142)
        
        XCTAssertEqual(sys.sunsetDate, "8:52 PM")
    }

    func testURLWithValidComponents() {
        // Given
        let baseURL = "https://api.weather.com"
        let city = "New York"
        let accessKey = "your_access_key"
        // When
        let WeatherRequest = WeatherRequest(city: city, accessKey: accessKey, baseURL: baseURL)
        // Then
        XCTAssertNotNil(WeatherRequest.url)
    }
    
    func testURLWithInvalidBaseURL() {
        // Given
        let invalidBaseURL = "invalid_url"
        let city = "New York"
        let accessKey = "your_access_key"
        // When
        let WeatherRequest = WeatherRequest(city: city, accessKey: accessKey, baseURL: invalidBaseURL)
        // Then
        XCTAssertNil(WeatherRequest.url)
    }
    
    func testURLWithMissingComponents() {
        // Given
        let baseURL = ""
        let missingCity = ""
        let missingAccessKey = ""
        // When
        let WeatherRequest = WeatherRequest(city: missingCity, accessKey: missingAccessKey, baseURL: baseURL)
        // Then
        XCTAssertNil(WeatherRequest.url)
    }

    func testIconImageForClearDay() {
        // Given
        let icon = WeatherIcon.clearDay
        // When
        let image = icon.getIconImage()
        // Then
        XCTAssertNotNil(image)
//        XCTAssertEqual(image.systemName, "sun.max")
    }
    
    func testIconImageForCloudyNight() {
        // Given
        let icon = WeatherIcon.cloudyNight
        // When
        let image = icon.getIconImage()
        // Then
        XCTAssertNotNil(image)
//        XCTAssertEqual(image.systemName, "cloud")
    }
    
    func testIconImageForRainNight() {
        // Given
        let icon = WeatherIcon.rainNight
        // When
        let image = icon.getIconImage()
        // Then
        XCTAssertNotNil(image)
//        XCTAssertEqual(image.systemName, "cloud.rain.fill")
    }
    
    func testIconImageForInvalidIcon() {
        // Given
        let icon = WeatherIcon(rawValue: "invalid_icon")
        // When
        let image = icon?.getIconImage()
        // Then
        XCTAssertNil(image)
    }
}
