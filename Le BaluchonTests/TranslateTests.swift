//
//  TranslateTests.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 15/06/2023.
//

import XCTest
@testable import Le_Baluchon

class TranslationServiceTests: XCTestCase {
    
    var translationService: TranslationServiceImplementation!
    var mockUrlSession: URLSessionMock!
//    var mockKeyService: MockKeyService!
    
    
    override func setUp() {
        super.setUp()
//        mockKeyService = MockKeyService()
        mockUrlSession = URLSessionMock()
        translationService = TranslationServiceImplementation(urlSession: mockUrlSession)
    }
    
    override func tearDown() {
        translationService = nil
//        mockKeyService = nil
        mockUrlSession = nil
        super.tearDown()
    }
    
    func test_getTranslation_success() {
        // Given
        let json = """
    {
        "data": {
            "translations": [
                {
                    "translatedText": "Bonjour"
                }
            ]
        }
    }
    """
        let data = Data(json.utf8)
        mockUrlSession.data = data
        mockUrlSession.error = nil
        // add status code 200 to the response
        mockUrlSession.urlResponse = HTTPURLResponse(url: URL(string: "https://www.testTranslation.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        // Create a translation request
        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Hello")
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Translation completed")
        
        // When
        translationService.getTranslation(request: translationRequest) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTAssertEqual(translationResponse.translatedText, "Bonjour")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    
    func test_getTranslation_failure() {
        // Given
        mockUrlSession.data = nil
        mockUrlSession.urlResponse = HTTPURLResponse(url: URL(string: "https://www.testTranslation.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Hello")
        let expectation = XCTestExpectation()
        
        // When
        translationService.getTranslation(request: translationRequest) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTFail("Expected failure, but got success: \(translationResponse)")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error)
                if error == TranslationError.noData {
                    // The error matches TranslationError.noData
                    expectation.fulfill()
                } else {
                    XCTFail("Expected TranslationError.noData, but got \(error)")
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }

    func test_getTranslation_failure_invalidResponse() {
        // Given
        let json = """
    {
        "data": {
            "translations": [
                {
                    "translatedText": "Bonjour"
                }
            ]
        }
    }
    """
        let data = Data(json.utf8)
        mockUrlSession.data = data
        mockUrlSession.error = nil
        // add status code 400 to the response
        mockUrlSession.urlResponse = HTTPURLResponse(url: URL(string: "https://www.testTranslation.com")!, statusCode: 418, httpVersion: nil, headerFields: nil)
        
        // Create a translation request
        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Hello")
        
        // Create an expectation for a background download task.
        let expectation = XCTestExpectation(description: "Translation completed")
        
        // When
        translationService.getTranslation(request: translationRequest) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTFail("Expected failure, but got success: \(translationResponse)")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error)
                if error == TranslationError.invalidResponse {
                    // The error matches TranslationError.invalidResponse
                    expectation.fulfill()
                } else {
                    XCTFail("Expected TranslationError.invalidResponse, but got \(error)")
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func test_getTranslation_failure_decodingError() {
        // Given
        let invalidJSON = """
            {
                "data": {
                    "translations": [
                        {
                            "translated": Bonjour
                        }
                    ]
                }
            }
        """
        let invalidData = invalidJSON.data(using: .utf8)!
        
        let validURLResponse = HTTPURLResponse(url: URL(string: "https://www.testTranslation.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        mockUrlSession.data = invalidData
        mockUrlSession.urlResponse = validURLResponse
        
        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Hello")
        
        let expectation = XCTestExpectation(description: "Translation decoding error")
        
        // When
        translationService.getTranslation(request: translationRequest) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTFail("Expected failure, but got success: \(translationResponse)")
            case .failure(let error):
                XCTAssertNotNil(error)
                XCTAssertEqual(error, TranslationError.decodingError(error.localizedDescription))
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }


    func test_getTranslation_failure_networkError() {
        // Given
        mockUrlSession.data = nil
        mockUrlSession.error = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil) // Simulez une erreur réseau
        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Hello")
        let expectation = XCTestExpectation()
        
        // When
        translationService.getTranslation(request: translationRequest) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTFail("Expected failure, but got success: \(translationResponse)")
                expectation.fulfill()
            case .failure(let error):
                XCTAssertNotNil(error)
                if error == TranslationError.networkError {
                    // L'erreur correspond à TranslationError.networkError
                    expectation.fulfill()
                } else {
                    XCTFail("Expected TranslationError.networkError, but got \(error)")
                    expectation.fulfill()
                }
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }

}
