//
//  Concurrent_API_CallsTests.swift
//  Concurrent API CallsTests
//
//  Created by Andrés Fonseca on 19/05/2024.
//

import XCTest
import OHHTTPStubs
@testable import Concurrent_API_Calls

class NetworkingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        HTTPStubs.removeAllStubs()
    }
    
    func testFetchEvery10thCharacter() {
            let stubbedResponse = """
                   <html>
                       <body>
                           <p>This is a sample paragraph. It contains some text.</p>
                           <h2>Heading 2</h2>
                           <span>Span text</span>
                       </body>
                   </html>
                   """
            let stubbedData = stubbedResponse.data(using: .utf8)!
            stub(condition: isHost("example.com")) { _ in
                return HTTPStubsResponse(data: stubbedData, statusCode: 200, headers: nil)
            }
            let viewModel = MainViewScreenViewModel()
            let expectation = XCTestExpectation(description: "Fetching every 10th character")
            let expectedEvery10thCharacters: [Character] = ["m", "g", "t"]

            viewModel.fetchEvery10thCharacter { result in
                switch result {
                case .success(let (text, every10thCharacter)):
                    XCTAssertFalse(text.isEmpty)
                    XCTAssertFalse(every10thCharacter.isEmpty)
                    XCTAssertEqual(every10thCharacter, expectedEvery10thCharacters)
                    
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Fetching every 10th character failed with error: \(error)")
                }
            }
        }
    
    func testWordCounterRequest() {
        let expectation = XCTestExpectation(description: "Word counter request")
        stub(condition: isHost("www.compass.com") && isPath("/about")) { _ in
            let responseString = "<p>This is a test response</p>"
            return HTTPStubsResponse(data: responseString.data(using: .utf8)!, statusCode: 200, headers: nil)
        }
        
        let viewModel = MainViewScreenViewModel()
        viewModel.fetchWordCounts { result in
            switch result {
            case .success(let wordCounts):
                XCTAssertEqual(wordCounts["this"], 1)
                XCTAssertEqual(wordCounts["is"], 1)
                XCTAssertEqual(wordCounts["a"], 1)
                XCTAssertEqual(wordCounts["test"], 1)
                XCTAssertEqual(wordCounts["response"], 1)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, got \(error)")
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
