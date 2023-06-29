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
    
//    class MockSession: URLSession {
//        var data: Data?
//        var error: Error?
//        
//        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
//            let data = self.data
//            let error = self.error
//            override func dataTask(with url: URL, callback: ()) {
//                callback(data, response, error)
//            }
//        }
//        
//    }
}
