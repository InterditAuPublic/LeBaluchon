//
//  WeatherTests.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 09/06/2023.
//

import XCTest
@testable import Le_Baluchon    

final class WeatherTests: XCTestCase {
    
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
      "lon":-0.13,
      "lat":51.51
    },
    "weather":[
      {
         "id":300,
         "main":"Drizzle",
         "description":"light intensity drizzle",
         "icon":"09d"
      }
    ],
    "base":"stations",
    "main":{
      "temp":280.32,
      "pressure":1012,
      "humidity":81,
      "temp_min":279.15,
      "temp_max":281.15
    },
    "visibility":10000,
    "wind":{
      "speed":4.1,
      "deg":80
    },
    "clouds":{
      "all":90
    },
    "dt":1485789600,
    "sys":{
      "type":1,
      "id":5091,
      "message":0.0103,
      "country":"GB",
      "sunrise":1485762037,
      "sunset":1485794875
    },
    "id":2643743,
    "name":"London",
    "cod":200
    }
    """
        let data = Data(json.utf8)
        mockUrlSession.data = data
        
        let expectation = XCTestExpectation()
        
        weatherService.getWeather(city: "London") { result in
            switch result {
            case .success(let weather):
                XCTAssertEqual(weather.name, "London")
                XCTAssertEqual(weather.main.temp, 280.32)
                XCTAssertEqual(weather.weather[0].description, "light intensity drizzle")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}

