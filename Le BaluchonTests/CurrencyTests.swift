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


func test_convert_withCache() {
// Given
let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
let amount = 100.0
let currencyCode = "USD"
let exchangeRate = 1.1234
currencyService.timestamp = Int(Date().timeIntervalSince1970)
currencyService.rates[currencyCode] = exchangeRate

let expectation = XCTestExpectation()

// When
currencyService.convert(amount: amount, country: currencyCode) { result in
// Then
let expectedResult = amount * exchangeRate
let roundedExpectedResult = Double(round(100 * expectedResult) / 100)
XCTAssertEqual(result, roundedExpectedResult)
expectation.fulfill()
}

wait(for: [expectation], timeout: 0.5)
}

func test_convert_withAPI() {
// Given
let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
let amount = 100.0
let currencyCode = "USD"
currencyService.timestamp = 0 // Mettre à jour le timestamp pour qu'il soit expiré

// Configuration pour que la requête API réussisse
let json = """
{
"date": "2018-02-22",
"historical": "",
"info": {
"rate": 1.1234,
"timestamp": 1519328414
},
"query": {
"amount": \(amount),
"from": "EUR",
"to": "USD"
},
"result": \(amount * 1.1234),
"success": true
}
"""
let data = Data(json.utf8)
mockUrlSession.data = data

let expectation = XCTestExpectation()

// When
currencyService.convert(amount: amount, country: currencyCode) { result in
// Then
XCTAssertEqual(result, 112.34)
expectation.fulfill()
}

wait(for: [expectation], timeout: 0.5)
}

func test_getCurrencyCodesWithAPI_success() {
// Given
let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
let expectedSymbols: [String: String] = ["USD": "US Dollar", "EUR": "Euro"]
let json = """
{
"success": true,
"symbols": {
    "USD": "US Dollar",
    "EUR": "Euro"
}
}
"""
let data = Data(json.utf8)
mockUrlSession.data = data

let expectation = XCTestExpectation()

// When
currencyService.getCurrencyCodesWithAPI { result in
// Then
switch result {
case .success(let symbols):
    XCTAssertEqual(symbols, expectedSymbols)
case .failure:
    XCTFail("Expected success, but got failure.")
}
expectation.fulfill()
}

wait(for: [expectation], timeout: 0.5)
}

func test_getCurrencyCodesWithAPI_failure() {
// Given
let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
let error = NSError(domain: "error", code: 400, userInfo: nil)
mockUrlSession.error = error

let expectation = XCTestExpectation()

// When
currencyService.getCurrencyCodesWithAPI { result in
// Then
switch result {
case .success:
    XCTFail("Expected failure, but got success.")
case .failure(let receivedError):
    XCTAssertEqual(receivedError as NSError, error)
}
expectation.fulfill()
}

wait(for: [expectation], timeout: 0.5)
}

func test_getCurrencyCodesWithAPI_invalidData() {
// Given
let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
mockUrlSession.data = nil

let expectation = XCTestExpectation()

// When
currencyService.getCurrencyCodesWithAPI { result in
// Then
switch result {
case .success:
    XCTFail("Expected failure, but got success.")
case .failure(let error):
    XCTAssertEqual(error as? CurrencyError, CurrencyError.invalidData)
}
expectation.fulfill()
}

wait(for: [expectation], timeout: 0.5)
}

func test_getCurrencyCodesWithAPI_decodingFailure() {
// Given
let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
let json = """
{
"success": true,
"symboly": {
    "USD": "US Dollar",
    "EUR": "Euro"
}
}
"""
let data = Data(json.utf8)
mockUrlSession.data = data

let expectation = XCTestExpectation()

// When
currencyService.getCurrencyCodesWithAPI { result in
// Then
switch result {
case .success:
    XCTFail("Expected failure, but got success.")
case .failure:
    break // Expected failure
}
expectation.fulfill()
}

wait(for: [expectation], timeout: 0.5)
}

func test_getRatesWithAPI_withRatesInMemory() {
// Given
let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
currencyService.rates = ["USD": 1.1234, "EUR": 0.8901]

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

func test_getCurrencyCodesWithAPI_withSuccessResult() {
    // Given
    let json = """
    {
        "success": true,
        "symbols": {
            "USD": "US Dollar",
            "EUR": "Euro"
        }
    }
    """
    let data = Data(json.utf8)
    mockUrlSession.data = data
    let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
    currencyService.symbols = [:] // Assurez-vous que symbols est vide au départ

    let expectation = XCTestExpectation()

    // When
    currencyService.getCurrencyCodes { symbols in
        // Then
        XCTAssertEqual(symbols["USD"], "US Dollar")
        XCTAssertEqual(symbols["EUR"], "Euro")
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.5)
}

func test_getCurrencyCodes_withSymbolsInMemory() {
    // Given
    let currencyService = CurrencyServiceImplementation(urlSession: mockUrlSession)
    currencyService.symbols = ["USD": "US Dollar", "EUR": "Euro"]

    let expectation = XCTestExpectation()

    // When
    currencyService.getCurrencyCodes { symbols in
        // Then
        XCTAssertEqual(symbols["USD"], "US Dollar")
        XCTAssertEqual(symbols["EUR"], "Euro")
        expectation.fulfill()
    }

    wait(for: [expectation], timeout: 0.5)
}



}
