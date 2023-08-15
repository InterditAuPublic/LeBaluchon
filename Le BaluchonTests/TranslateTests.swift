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
    var mockSession: URLSessionMock!

//
//    override func setUp() {
//        super.setUp()
//        mockSession = URLSessionMock()
//        translationService = TranslationServiceImplementation(session: mockSession)
//    }
//
//    override func tearDown() {
//        translationService = nil
//        mockSession = nil
//        super.tearDown()
//    }
//
//  func testGetTranslationShouldPostFailedCallbackIfError() {
//    // Given
//      let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Bonjour")
////    let error = Error?
//    mockSession.data = nil
//      mockSession.error = nil
////    mockSession.error = error
//
//    // When
//    let expectation = XCTestExpectation(description: "Wait for queue change.")
//    translationService.getTranslation(request: translationRequest) { (success, response) in
//      // Then
//      XCTAssertFalse(success)
//      XCTAssertNil(response)
//      expectation.fulfill()
//    }
//    wait(for: [expectation], timeout: 0.01)
//  }
//
//    func testGetTranslationShouldPostFailedCallbackIfNoData() {
//        // Given
//        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Bonjour")
//        mockSession.data = nil
//        mockSession.error = nil
//
//        // When
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        translationService.getTranslation(request: translationRequest) { (success, response) in
//        // Then
//        XCTAssertFalse(success)
//        XCTAssertNil(response)
//        expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 0.01)
//    }
//
//     func testGetTranslationUnreliable() {
//
//        // Given
//        let translationRequest = TranslationRequest(source: "en", target: "fr", text: "Bonjour")
//        mockSession.data = nil
//        mockSession.error = nil
//
//        // When
//        let expectation = XCTestExpectation(description: "Wait for queue change.")
//        translationService.getTranslation(request: translationRequest) { (success, response) in
//        // Then
//        XCTAssertFalse(success)
//        XCTAssertNil(response)
//        expectation.fulfill()
//        }
//        wait(for: [expectation], timeout: 10)
//
//    }

}
