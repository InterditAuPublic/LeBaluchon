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
                XCTAssertEqual(error, WeatherServiceError.noData)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
}

