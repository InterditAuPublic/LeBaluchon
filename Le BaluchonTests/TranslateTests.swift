//
//  TranslateTests.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 15/06/2023.
//

import XCTest

class TranslationServiceTests: XCTestCase {
    var translationService: TranslationService!
    var mockSession: MockURLSession!

    override func setUp() {
        super.setUp()
        mockSession = MockURLSession()
        translationService = TranslationServiceImplementation(session: mockSession)
    }

    override func tearDown() {
        translationService = nil
        mockSession = nil
        super.tearDown()
    }

    func testGetTranslation_SuccessfulRequest_ReturnsTranslationResponse() {
        // Given
        let expectation = self.expectation(description: "Translation service callback")
        let request = TranslationRequest(source: "en", target: "fr", text: "Hello")
        let responseJSON = """
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
        mockSession.mockDataTaskResponse = (data: responseJSON.data(using: .utf8), response: HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil), error: nil)

        // When
        translationService.getTranslation(request: request) { success, response in
            // Then
            XCTAssertTrue(success, "Translation request should be successful")
            XCTAssertNotNil(response, "Translation response should not be nil")
            XCTAssertEqual(response?.translatedText, "Bonjour", "Translated text should be 'Bonjour'")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetTranslation_InvalidURL_ReturnsError() {
        // Given
        let expectation = self.expectation(description: "Translation service callback")
        let request = TranslationRequest(source: "en", target: "fr", text: "Hello")
        let invalidBaseURL = "invalidURL"

        // When
        translationService.getTranslation(request: request) { success, response in
            // Then
            XCTAssertFalse(success, "Translation request should fail")
            XCTAssertNil(response, "Translation response should be nil")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }

    // Mock URLSession for testing
    class MockURLSession: URLSession {
        var mockDataTaskResponse: (data: Data?, response: URLResponse?, error: Error?)?

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
        }
    }

    // Mock URLSessionDataTask for testing
    class MockURLSessionDataTask: URLSessionDataTask {
        var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
        var mockResponse: (data: Data?, response: URLResponse?, error: Error?)?

        override func resume() {
            completionHandler?(mockResponse?.data, mockResponse?.response, mockResponse?.error)
        }
    }
}
