//
//  IntradayViewModelTests.swift
//  StockDemoTests
//
//  Created by Rahul Dange on 29/03/21.
//

import XCTest
@testable import StockDemo

class IntradayViewModelTests: XCTestCase {

    var viewModel: IntradayViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = IntradayViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testTimeSeriesModelCreation() {
        let timeSeriesModel = loadJson(fileName: "IntradaySample")
        XCTAssertNotNil(timeSeriesModel, "Failed to initialize TimeSeriesModel")
    }
    
    func testIntradayAPI() {
        let apiExpectation = expectation(description: "Intraday API testing.")
        viewModel?.fetchIntradayTimeSeries(for: "IBM") { msg in
            XCTAssertTrue(msg.isEmpty, "Intraday API failed")
            apiExpectation.fulfill()
        }
        waitForExpectations(timeout: 30, handler: nil)
    }
    
    func testIntradayDataSortingDateParam() {
        let timeSeriesModel = loadJson(fileName: "IntradaySample")
        let timeSeriesViewModelDict = timeSeriesModel?.getTimeSeriesDict() ?? [:]
        viewModel?.setTimeSeriesModelDict(timeSeriesModelDict: timeSeriesViewModelDict)
        var sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.dateAscending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.key, "2021-03-26 19:04:00", "Date ascending sorting failing.")
        
        /// test for descending
        sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.dateDescending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.key, "2021-03-26 19:43:00", "Date descending sorting failing.")
    }
    
    func testIntradayDataSortingHighParam() {
        let timeSeriesModel = loadJson(fileName: "IntradaySample")
        let timeSeriesViewModelDict = timeSeriesModel?.getTimeSeriesDict() ?? [:]
        viewModel?.setTimeSeriesModelDict(timeSeriesModelDict: timeSeriesViewModelDict)
        var sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.highAscending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.value.high, "105.7000", "High ascending sorting failing.")
        
        /// test for descending
        sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.highDescending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.value.high, "135.7000", "High descending sorting failing.")
    }
    
    func testIntradayDataSortingLowParam() {
        let timeSeriesModel = loadJson(fileName: "IntradaySample")
        let timeSeriesViewModelDict = timeSeriesModel?.getTimeSeriesDict() ?? [:]
        viewModel?.setTimeSeriesModelDict(timeSeriesModelDict: timeSeriesViewModelDict)
        var sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.lowAscending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.value.low, "105.7000", "Low ascending sorting failing.")
        
        /// test for descending
        sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.lowDescending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.value.low, "135.7000", "Low descending sorting failing.")
    }
    
    func testIntradayDataSortingOpenParam() {
        let timeSeriesModel = loadJson(fileName: "IntradaySample")
        let timeSeriesViewModelDict = timeSeriesModel?.getTimeSeriesDict() ?? [:]
        viewModel?.setTimeSeriesModelDict(timeSeriesModelDict: timeSeriesViewModelDict)
        var sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.openAscending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.value.open, "105.7000", "Open ascending sorting failing.")
        
        /// test for descending
        sortedTimeSeriesModelValues = viewModel?.sortTimeSeriesModelDict(with: SortOptions.openDescending.rawValueString())
        XCTAssertEqual(sortedTimeSeriesModelValues?.first?.value.low, "135.7000", "Open descending sorting failing.")
    }
}

/// extension to load sample JSON into tests.
extension XCTestCase {
    func loadJson(fileName: String) -> TimeSeriesModel? {
        let decoder = JSONDecoder()
        let bundle = Bundle(for: type(of: self))
        
        guard
            let filepath = bundle.path(forResource: fileName, ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)),
            let timeSeriesModel = try? decoder.decode(TimeSeriesModel.self, from: data)
       else {
            return nil
       }

       return timeSeriesModel
    }
}
