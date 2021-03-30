//
//  StockDemoUITests.swift
//  StockDemoUITests
//
//  Created by Rahul Dange on 26/03/21.
//

import XCTest

class IntradayUITests: XCTestCase {
    
    var app: XCUIApplication?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app = XCUIApplication()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testSymbolFieldPresent() {
        app?.launch()
        let symbolField = app?.textFields["symbol-field"]
        XCTAssert(symbolField!.exists, "Symbol textfield not present")
    }
    
    func testGetInfoBtnPresent() {
        app?.launch()
        let infoBtn = app?.buttons["info-button"]
        XCTAssert(infoBtn!.exists, "Get Info button not present")
    }
    
    func testIntradayTableviewPresent() {
        app?.launch()
        let intradayTableView = app?.tables["intraday-tableview"]
        XCTAssert(intradayTableView!.exists, "Get intraday tableview not present")
    }
    
    func testNoDataLabelPresent() {
        app?.launch()
        let noDataLabel = app?.staticTexts["no-data-label"]
        XCTAssert(noDataLabel!.exists, "No data label not present")
    }
    
    func testGetInfoBtnState() {
        app?.launch()
        let infoBtn = app?.buttons["info-button"]
        XCTAssert(!infoBtn!.isEnabled, "Get Info button should be disabled")
        
        let symbolField = app?.textFields["symbol-field"]
        symbolField!.tap()
        symbolField!.typeText("ABC")
        
        XCTAssert(infoBtn!.isEnabled, "Get Info button should be enabled")
    }
    
    func testMinimumSymbolLength() {
        app?.launch()
        let symbolField = app?.textFields["symbol-field"]
        symbolField!.tap()
        symbolField!.typeText("AB")

        let infoBtn = app?.buttons["info-button"]
        infoBtn?.tap()

        let alert = app?.alerts["common-alert"]
        XCTAssert(alert!.exists, "Minimum symbol length failed.")
    }
    
    func testIfActivityIndicatorPresent() {
        app?.launch()
        let symbolField = app?.textFields["symbol-field"]
        symbolField!.tap()
        symbolField!.typeText("IBM")
        
        let infoBtn = app?.buttons["info-button"]
        infoBtn!.tap()
        
        let activityIndicator = app?.activityIndicators.firstMatch
        XCTAssert(activityIndicator!.exists, "Activity indicator should be present if API is in progress")
    }
    
    func testIntradayNavigatonBarTitle() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        tabBar!.buttons["Intraday"].tap()
        let navBar = app?.navigationBars.firstMatch
        
        XCTAssertEqual(navBar!.identifier, "Intraday", "Intraday Navbar title is wrong")
    }
    
    func testDailyNavigatonBarTitle() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        let navBar = app?.navigationBars.firstMatch
        
        XCTAssertEqual(navBar!.identifier, "Daily Compare", "Intraday Navbar title is wrong")
    }
    
    func testSettingsNavigatonBarTitle() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Settings"].tap()
        let navBar = app?.navigationBars.firstMatch
        
        XCTAssertEqual(navBar!.identifier, "Settings", "Intraday Navbar title is wrong")
    }
}
