//
//  StockDemoTests.swift
//  StockDemoTests
//
//  Created by Rahul Dange on 26/03/21.
//

import XCTest
@testable import StockDemo

class UtilityUnitTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRequiredDateStringIntraday() {
        let incomingDateString = "2021-03-24 20:00:00"
        let requiredDateString = Utility.getDateStringFrom(dateString: incomingDateString)
        
        XCTAssertEqual(requiredDateString, "24/03/2021 20:00", "Dates not equal for Intraday")
    }
    
    func testRequiredDateStringDaily() {
        let incomingDateString = "2021-03-24"
        let requiredDateString = Utility.getDateStringFrom(dateString: incomingDateString, isIntradayDate: false)
        
        XCTAssertEqual(requiredDateString, "24/03/2021", "Dates not equal for Daily")
    }
}
