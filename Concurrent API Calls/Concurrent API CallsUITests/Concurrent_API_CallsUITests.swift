//
//  Concurrent_API_CallsUITests.swift
//  Concurrent API CallsUITests
//
//  Created by Andrés Fonseca on 19/05/2024.
//

import XCTest
import OHHTTPStubs

class UITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testFetchData() throws {
        app.buttons["runRequestsButton"].tap()
        
        let everyTenTextView = app.textViews["everyTenTextView"]
        let wordCountTextView = app.textViews["wordCountTextView"]
        
        XCTAssertTrue(everyTenTextView.waitForExistence(timeout: 10))
        XCTAssertTrue(wordCountTextView.waitForExistence(timeout: 10))
        
        XCTAssertFalse(everyTenTextView.value as! String == "")
        XCTAssertFalse(wordCountTextView.value as! String == "")
    }

}
