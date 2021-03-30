//
//  SettingsUITests.swift
//  StockDemoUITests
//
//  Created by Rahul Dange on 31/03/21.
//

import XCTest

class SettingsUITests: XCTestCase {
    
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
    
    func testApiKeyFieldPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Settings"].tap()
        
        let apikeyField = app?.textFields["api-key-field"]
        XCTAssert(apikeyField!.exists, "API key textfield not present")
    }
    
    func testIntervalFieldPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Settings"].tap()
        
        let intervalField = app?.textFields["interval-field"]
        XCTAssert(intervalField!.exists, "Interval field not present")
    }
    
    func testOutputsizeControlPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Settings"].tap()
        
        let outputsizeControl = app?.segmentedControls["outputsize-control"]
        XCTAssert(outputsizeControl!.exists, "Outputsize control not present")
    }
    
    func testSaveBtnPresent() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Settings"].tap()
        
        let saveBtn = app?.buttons["settings-save-button"]
        XCTAssert(saveBtn!.exists, "settings save button not present")
    }
    
    func testIntervalActionsheetPopulate() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Settings"].tap()
        
        let intervalField = app?.textFields["interval-field"]
        intervalField?.tap()
        
        let actionSheet = app?.sheets["interval-options-sheet"]
        XCTAssert(actionSheet!.exists, "Interval options action sheet not populated")
    }
    
    func testSettingsSaveSuccess() {
        app?.launch()
        let tabBar = app?.tabBars["Tab Bar"]
        tabBar!.buttons["Settings"].tap()
        
        let saveBtn = app?.buttons["settings-save-button"]
        saveBtn?.tap()
        
        let alert = app?.alerts["common-alert"]
        XCTAssert(alert!.exists, "Settings save success scenario failed.")
    }
}
