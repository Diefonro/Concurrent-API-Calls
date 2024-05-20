//
//  Concurrent_API_CallsUITests.swift
//  Concurrent API CallsUITests
//
//  Created by Andrés Fonseca on 19/05/2024.
//

import XCTest

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
        // Tap the button to run requests
        app.buttons["runRequestsButton"].tap()
        
        // Wait for the data to be fetched and displayed
        let everyTenTextView = app.textViews["everyTenTextView"]
        let wordCountTextView = app.textViews["wordCountTextView"]
        
        XCTAssertTrue(everyTenTextView.waitForExistence(timeout: 10))
        XCTAssertTrue(wordCountTextView.waitForExistence(timeout: 10))
        
        // Verify that the text views are not empty
        XCTAssertFalse(everyTenTextView.value as! String == "")
        XCTAssertFalse(wordCountTextView.value as! String == "")
    }
}
