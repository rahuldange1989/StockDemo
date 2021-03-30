//
//  SettingsUnitTests.swift
//  StockDemoTests
//
//  Created by Rahul Dange on 31/03/21.
//

import XCTest
@testable import StockDemo

class SettingsUnitTests: XCTestCase {
    
    var viewModel: SettingsViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = SettingsViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testPopulateSettingsFunction() {
        AppConstants.API.api_key_alpha_vantage = "78TV77XPOXDOJC4Z"
        AppConstants.API.interval = "5min"
        AppConstants.API.outputsize = "compact"
        
        viewModel?.populateSettingsValue(completion: { (apikey, interval, outputsize, _) in
            XCTAssertEqual(apikey, "78TV77XPOXDOJC4Z", "api key is not populated")
            XCTAssertEqual(interval, "5min", "interval is not populated")
            XCTAssertEqual(outputsize, "compact", "outputsize is not populated")
        })
    }
    
    func testSaveSettingsFunction() {
        /// get copy of existing settings
        let apiKey = AppConstants.API.api_key_alpha_vantage
        let interval = AppConstants.API.interval
        let outputsize = AppConstants.API.outputsize
        
        viewModel?.saveSettings(apiKey: apiKey, interval: interval, outputSize: outputsize, completion: { msg in
            XCTAssertTrue(msg.isEmpty, "save settings failed")
        })
    }
}
