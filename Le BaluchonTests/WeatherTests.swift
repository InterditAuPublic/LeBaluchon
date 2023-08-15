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
weatherService = WeatherServiceImplementation()
mockUrlSession = URLSessionMock()
weatherService.session = mockUrlSession
}

override func tearDown() {
weatherService = nil
mockUrlSession = nil
super.tearDown()
}

}

