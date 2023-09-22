//
//  File.swift
//  Le BaluchonTests
//
//  Created by Melvin Poutrel on 27/07/2023.
//

import XCTest
@testable import Le_Baluchon

final class ServiceTests: XCTestCase {
    
    func testLoadData() {
        
        // Given
        let text = "bonjour"
        let data = Data(text.utf8)
        let mockUrlSession = URLSessionMock()
        mockUrlSession.data = data
        let s = Service()
        s.urlSession = mockUrlSession
        
        let expectation = XCTestExpectation()
        
        // When
        s.loadData { result in
            
            // Then
            XCTAssertTrue(result)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testLoadData_false() {
        
        // Given
        let text = "zelfjnkzefzerfk"
        let data = Data(text.utf8)
        let mockUrlSession = URLSessionMock()
        mockUrlSession.data = data
        let s = Service()
        s.urlSession = mockUrlSession
        
        let expectation = XCTestExpectation()
        
        // When
        s.loadData { result in
            
            // Then
            XCTAssertFalse(result)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.1) // 0.1 is enough because it synchronous
    }
    
}

class URLSessionDataTaskMock: URLSessionDataTaskProtocol {
    func cancel() {
    }
    
    let completionHandler: () -> Void
    
    init(completionHandler: @escaping () -> Void) {
        self.completionHandler = completionHandler
    }
    
    func resume() {
        completionHandler()
    }
}

class URLSessionMock: URLSessionProtocol {
    
    var data: Data?
    var urlResponse: URLResponse?
    var error: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> some URLSessionDataTaskProtocol {
        return URLSessionDataTaskMock(completionHandler: {
            completionHandler(self.data, self.urlResponse, self.error)
        })
    }
    
}
