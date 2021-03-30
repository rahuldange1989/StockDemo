//
//  DailyUITests.swift
//  StockDemoUITests
//
//  Created by Rahul Dange on 30/03/21.
//

import XCTest

class DailyUITests: XCTestCase {
    
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
    
    func testSymbolsFieldPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let symbolsField = app?.textFields["symbols-field"]
        XCTAssert(symbolsField!.exists, "Symbols textfield not present")
    }
    
    func testCompareBtnPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let compareBtn = app?.buttons["compare-button"]
        XCTAssert(compareBtn!.exists, "Compare button not present")
    }
    
    func testDailyTableviewPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let dailyTableView = app?.tables["daily-tableview"]
        XCTAssert(dailyTableView!.exists, "Daily tableview not present")
    }
    
    func testDailyNoDataLabelPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let noDataLabel = app?.staticTexts["no-data-label-daily"]
        XCTAssert(noDataLabel!.exists, "No data label daily not present")
    }
    
    func testGetInfoBtnState() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let compareBtn = app?.buttons["compare-button"]
        XCTAssert(!compareBtn!.isEnabled, "Compare button should be disabled")
        
        let symbolsField = app?.textFields["symbols-field"]
        symbolsField!.tap()
        symbolsField!.typeText("ABC")
        
        XCTAssert(compareBtn!.isEnabled, "Get Info button should be enabled")
    }
    
    func testMinimumSymbolLength() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let symbolsField = app?.textFields["symbols-field"]
        symbolsField!.tap()
        symbolsField!.typeText("AB")

        let compareBtn = app?.buttons["compare-button"]
        compareBtn?.tap()

        let alert = app?.alerts["common-alert"]
        XCTAssert(alert!.exists, "Daily Minimum symbol length failed.")
    }
    
    func testMaximumSymbols() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let symbolsField = app?.textFields["symbols-field"]
        symbolsField!.tap()
        symbolsField!.typeText("ABC,DEF,GHI,JKL")

        let compareBtn = app?.buttons["compare-button"]
        compareBtn?.tap()

        let alert = app?.alerts["common-alert"]
        XCTAssert(alert!.exists, "Daily maximum symbols count failed.")
    }
    
    func testConsecutiveSameSymbolsError() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let symbolsField = app?.textFields["symbols-field"]
        symbolsField!.tap()
        symbolsField!.typeText("ABC,ABC")

        let compareBtn = app?.buttons["compare-button"]
        compareBtn?.tap()

        let alert = app?.alerts["common-alert"]
        XCTAssert(alert!.exists, "Daily maximum symbols count failed.")
    }
    
    func testFirstAndLastSameSymbolsError() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let symbolsField = app?.textFields["symbols-field"]
        symbolsField!.tap()
        symbolsField!.typeText("ABC,DEF,ABC")

        let compareBtn = app?.buttons["compare-button"]
        compareBtn?.tap()

        let alert = app?.alerts["common-alert"]
        XCTAssert(alert!.exists, "Daily maximum symbols count failed.")
    }
    
    func testIfActivityIndicatorPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Daily"].tap()
        
        let symbolsField = app?.textFields["symbols-field"]
        symbolsField!.tap()
        symbolsField!.typeText("IBM,SHOP")
        
        let compareBtn = app?.buttons["compare-button"]
        compareBtn!.tap()
        
        let activityIndicator = app?.activityIndicators.firstMatch
        XCTAssert(activityIndicator!.exists, "Activity indicator should be present if API is in progress")
    }
}
