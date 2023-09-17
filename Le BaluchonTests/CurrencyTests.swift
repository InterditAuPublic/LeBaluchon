//
//  WeatherTest.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 15/06/2023.
//

import XCTest
@testable import Le_Baluchon

final class CurrencyServiceTests: XCTestCase {

var currencyService: CurrencyServiceImplementation!
var mockUrlSession: URLSessionMock!

override func setUp() {
super.setUp()
mockUrlSession = URLSessionMock()
currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
}

override func tearDown() {
currencyService = nil
mockUrlSession = nil
super.tearDown()
}

func test_getCurrencyCodes_with_api_succeeds() {

// Given
let json = """
{
"success": true,
"symbols": {
"USD": "US Dollar",
"EUR": "Euro",
}
}
"""
let data = Data(json.utf8)
mockUrlSession.data = data

let expectation = XCTestExpectation()

// When
currencyService.getCurrencyCodesWithAPI { result in
        switch result {
        case .success(let symbols):
            // Then
            XCTAssertEqual(symbols["USD"], "US Dollar")
            XCTAssertEqual(symbols["EUR"], "Euro")
            expectation.fulfill()
        case .failure(let error):
            XCTFail("Expected success, but got failure: \(error)")
            expectation.fulfill()

        }
    }
    wait(for: [expectation], timeout: 0.5)
}

func test_getCurrencyCodes_with_api_return_false() {

// Given
let json = """
{
"success": false,
"symbols": {
}
}
"""
let data = Data(json.utf8)
mockUrlSession.data = data

let expectation = XCTestExpectation()

// When
currencyService.getCurrencyCodesWithAPI { result in
        switch result {
        case .success(let symbols):
            // Then
            XCTAssertEqual(symbols.count, 0)
            expectation.fulfill()
        case .failure(let error):
            XCTFail("Expected success, but got failure: \(error)")
            expectation.fulfill()
        }
    }
    wait(for: [expectation], timeout: 0.5)
}

func test_getCurrencyCodes_with_api_return_invalidData() {
    
    // Given
    mockUrlSession.data = nil
    let expectation = XCTestExpectation()
    
    // When
    currencyService.getCurrencyCodesWithAPI { result in
        switch result {
        case .success(let symbols):
            // Then
            XCTAssertNil(symbols)
            XCTFail("Expected failure, but got success")
            expectation.fulfill()

        case .failure(let error):
            // check if error is not nil and is equal to the error we created CurrencyError.invalidData
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? CurrencyError, CurrencyError.invalidData)
            expectation.fulfill()
        }
}
wait(for: [expectation], timeout: 0.5)

}


func test_getRates_with_api_succeeds() {

// Given
let json = """
{
  "base": "EUR",
  "date": "2022-04-14",
  "rates": {
    "USD": 1.1234,
    "EUR": 0.8901,
  },
  "success": true,
  "timestamp": 1519296206
}
"""
let data = Data(json.utf8)
mockUrlSession.data = data
let expectation = XCTestExpectation()

// When
currencyService.getRatesWithAPI { rates in
    // Then
    XCTAssertEqual(rates?["USD"], 1.1234)
    XCTAssertEqual(rates?["EUR"], 0.8901)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}

func test_getRates_with_api_fails() {

// Given
mockUrlSession.error = NSError(domain: "error", code: 400, userInfo: nil)
let expectation = XCTestExpectation()

// When
currencyService.getRatesWithAPI { rates in
    // Then
    XCTAssertNil(rates)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}

func test_getRates_with_api_returns_nil() {

// Given
mockUrlSession.data = nil
let expectation = XCTestExpectation()

// When
currencyService.getRatesWithAPI { rates in
    // Then
    XCTAssertNil(rates)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}

func test_getRates_with_api_returns_empty_data() {

// Given
mockUrlSession.data = Data()
let expectation = XCTestExpectation()

// When
currencyService.getRatesWithAPI { rates in
    // Then
    XCTAssertNil(rates)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}

func test_convert_with_api_succeeds() {

// Given
let json = """
{
  "date": "2018-02-22",
  "historical": "",
  "info": {
    "rate": 148.972231,
    "timestamp": 1519328414
  },
  "query": {
    "amount": 25,
    "from": "GBP",
    "to": "JPY"
  },
  "result": 3724.305775,
  "success": true
}
"""
let data = Data(json.utf8)
mockUrlSession.data = data
let expectation = XCTestExpectation()

// When
currencyService.convert(amount: 1.0, country: "USD") { result in
    // Then
    XCTAssertEqual(result, 3724.31)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}

func test_convert_with_api_fails() {

// Given
mockUrlSession.error = NSError(domain: "error", code: 400, userInfo: nil)
let expectation = XCTestExpectation()

// When
currencyService.convert(amount: 1.0, country: "USD") { result in
    // Then
    XCTAssertNil(result)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}

func test_convert_with_api_returns_nil() {

// Given
mockUrlSession.data = nil
let expectation = XCTestExpectation()

// When
currencyService.convert(amount: 1.0, country: "USD") { result in
    // Then
    XCTAssertNil(result)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}

func test_convert_with_api_returns_empty_data() {

// Given
mockUrlSession.data = Data()
let expectation = XCTestExpectation()

// When
currencyService.convert(amount: 1.0, country: "USD") { result in
    // Then
    XCTAssertNil(result)
    expectation.fulfill()
}
wait(for: [expectation], timeout: 0.5)
}
}
