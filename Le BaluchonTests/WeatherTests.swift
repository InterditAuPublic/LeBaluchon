//
//  WeatherTests.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 09/06/2023.
//

import XCTest
@testable import Le_Baluchon

final class WeatherServiceTests: XCTestCase {

var weatherService: WeatherServiceImplementation!
var mockUrlSession: URLSessionMock!

override func setUp() {
    super.setUp()
    mockUrlSession = URLSessionMock()
    weatherService = WeatherServiceImplementation(urlSession: mockUrlSession)
}

override func tearDown() {
    weatherService = nil
    mockUrlSession = nil
    super.tearDown()
}

func test_get_weather_from_api_succeded() {
    let json = """
    {
       "coord":{
          "lon":-74.006,
          "lat":40.7143
       },
       "weather":[
          {
             "id":800,
             "main":"Clear",
             "description":"clear sky",
             "icon":"01d"
          }
       ],
       "base":"stations",
       "main":{
          "temp":14.17,
          "feels_like":13.52,
          "temp_min":12.13,
          "temp_max":15.68,
          "pressure":1019,
          "humidity":72
       },
       "visibility":10000,
       "wind":{
          "speed":7.6,
          "deg":360,
          "gust":10.73
       },
       "clouds":{
          "all":0
       },
       "dt":1694777590,
       "sys":{
          "type":2,
          "id":2008776,
          "country":"US",
          "sunrise":1694774189,
          "sunset":1694819185
       },
       "timezone":-14400,
       "id":5128581,
       "name":"New York",
       "cod":200
    }
"""
    let data = Data(json.utf8)
    mockUrlSession.data = data
    
    let expectation = XCTestExpectation()
    
    weatherService.getWeather(city: "New York") { result in
        switch result {
        case .success(let weather):
            XCTAssertEqual(weather.name, "New York")
            XCTAssertEqual(weather.main.temp, 14.17)
            XCTAssertEqual(weather.weather[0].description, "clear sky")
            expectation.fulfill()
        case .failure(let error):
            XCTFail("Expected success, but got failure: \(error)")
            expectation.fulfill()
        }
    }
    
    wait(for: [expectation], timeout: 0.5)
}

func test_get_weather_from_api_failed() {
    let json = """
"""
    let data = Data(json.utf8)
    mockUrlSession.data = data
    
    let expectation = XCTestExpectation()
    
    weatherService.getWeather(city: "New York") { result in
        print(result)
        switch result {
        case .success(let weather):
            XCTAssertNil(weather)
            expectation.fulfill()
        case .failure(let error):
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
    }
    
    wait(for: [expectation], timeout: 0.5)
}

func test_getWeather_returnsCachedWeather() {
    // Given
    let city = "Paris"
    let json = """
    {
       "coord":{
          "lon":-74.006,
          "lat":40.7143
       },
       "weather":[
          {
             "id":800,
             "main":"Clear",
             "description":"clear sky",
             "icon":"01d"
          }
       ],
       "base":"stations",
       "main":{
          "temp":14.17,
          "feels_like":13.52,
          "temp_min":12.13,
          "temp_max":15.68,
          "pressure":1019,
          "humidity":72
       },
       "visibility":10000,
       "wind":{
          "speed":7.6,
          "deg":360,
          "gust":10.73
       },
       "clouds":{
          "all":0
       },
       "dt":1728599699,
       "sys":{
          "type":2,
          "id":2008776,
          "country":"US",
          "sunrise":1694774189,
          "sunset":1694819185
       },
       "timezone":-14400,
       "id":5128581,
       "name":"New York",
       "cod":200
    }
"""

    let data = Data(json.utf8)
    let cachedWeather = try! JSONDecoder().decode(WeatherResponse.self, from: data)
    weatherService.cityWeathers[city] = cachedWeather
    
    
    // Create an expectation for a background request.
    let expectation = XCTestExpectation(description: "Cached weather returned")

    // When
    weatherService.getWeather(city: city) { result in
        // Then
        switch result {
        case .success(let weather):
            XCTAssertNotNil(weather)
            expectation.fulfill()
        case .failure(let error):
            XCTFail("Expected success, but got failure: \(error)")
            expectation.fulfill()
        }
    }

    wait(for: [expectation], timeout: 0.5)
}

func test_getWeather_networkError() {
    // Given
    let city = "London"
    let mockError = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
    mockUrlSession.error = mockError

    // Create an expectation for a background request.
    let expectation = XCTestExpectation(description: "Network error")

    // When
    weatherService.getWeather(city: city) { result in
        // Then
        switch result {
        case .success(let weatherResponse):
            XCTFail("Expected failure, but got success: \(weatherResponse)")
            expectation.fulfill()
        case .failure(let error):
            if case WeatherServiceError.networkError(let returnedError) = error {
                XCTAssertEqual(returnedError as NSError, mockError)
                expectation.fulfill()
            } else {
                XCTFail("Expected WeatherServiceError.networkError, but got \(error)")
                expectation.fulfill()
            }
        }
    }

    wait(for: [expectation], timeout: 0.5)
}

func test_getWeatherFromAPI_networkError() {
        // Given
        let city = "Paris"
        let expectedError = NSError(domain: "MockErrorDomain", code: 42, userInfo: nil)
        mockUrlSession.error = expectedError

        let expectation = XCTestExpectation(description: "Expecting a network error")

        // When
        weatherService.getWeatherFromAPI(city: city) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                if case .networkError(let receivedError) = error {
                    XCTAssertEqual(receivedError as NSError, expectedError)
                } else {
                    XCTFail("Expected networkError, but got: \(error)")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func test_getWeatherFromAPI_noData() {
        // Given
        let city = "New York"
        mockUrlSession.data = nil

        let expectation = XCTestExpectation(description: "Expecting no data error")

        // When
        weatherService.getWeatherFromAPI(city: city) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                if case .noData = error {
                    // Success
                } else {
                    XCTFail("Expected noData, but got: \(error)")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func test_getWeatherFromAPI_apiError() {
        // Given
        let city = "London"
        let json = """
        {
            "cod": "404",
            "message": "City not found"
        }
        """
        let data = Data(json.utf8)
        mockUrlSession.data = data

        let expectation = XCTestExpectation(description: "Expecting an API error")

        // When
        weatherService.getWeatherFromAPI(city: city) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                        if case .apiError(let message) = error {
                            XCTAssertEqual(message, "City not found")
                        } else {
                            XCTFail("Expected apiResponseError, but got: \(error)")
                        }
                        expectation.fulfill()
                    }
        }

        wait(for: [expectation], timeout: 0.5)
    }

    func test_getWeatherFromAPI_decodingError() {
        // Given
        let city = "Berlin"
        let json = """
        {
            "invalidJSON": "invalidValue"
        }
        """
        let data = Data(json.utf8)
        mockUrlSession.data = data

        let expectation = XCTestExpectation(description: "Expecting a decoding error")

        // When
        weatherService.getWeatherFromAPI(city: city) { result in
            // Then
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                if case .decodingError = error {
                    // Success
                } else {
                    XCTFail("Expected decodingError, but got: \(error)")
                }
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 0.5)
    }


}

