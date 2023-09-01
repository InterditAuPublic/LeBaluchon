//
//  TranslateTests.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 15/06/2023.
//

import XCTest
@testable import Le_Baluchon

class TranslationServiceTests: XCTestCase {
    
    var translationService: TranslationService!
    var mockUrlSession: URLSessionMock!
    
    
    override func setUp() {
        super.setUp()
        mockUrlSession = URLSessionMock()
        translationService = TranslationServiceImplementation(urlSession: mockUrlSession)
    }
    
    override func tearDown() {
        translationService = nil
        mockUrlSession = nil
        super.tearDown()
    }
    
    func testGetTranslationUnreliable() {
        
        // Given
        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Bonjour")
        mockUrlSession.data = nil
        mockUrlSession.error = nil
        
        // When
        let expectation = XCTestExpectation(description: "Wait for queue change.")
        // use result instead of success and response
        translationService.getTranslation(request: translationRequest) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTAssertNil(translationResponse)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
            }
        }
    }
    
    
    func test_translation_succeeds() {
        // Given
        let json = """
    {
        "translatedText": "Bonjour"
    }
    """
        let data = Data(json.utf8)
        mockUrlSession.data = data
        
        let expectation = XCTestExpectation()
        
        // When
        translationService.getTranslation(request: TranslationRequest(source: "en", target: "fr", text: "Hello")) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTAssertEqual(translationResponse.translatedText, "Bonjour")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5)
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
        
        let expectation = XCTestExpectation(description: "Translation completed")
        
        // When
        translationService.getTranslation(request: TranslationRequest(source: "en", target: "fr", text: "Hello")) { result in
            // Then
            switch result {
            case .success(let translationResponse):
                XCTAssertEqual(translationResponse.translatedText, "Bonjour")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5)
    }
}

