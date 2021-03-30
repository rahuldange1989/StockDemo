//
//  DailyViewModelUnitTests.swift
//  StockDemoTests
//
//  Created by Rahul Dange on 30/03/21.
//

import XCTest
@testable import StockDemo

class DailyViewModelTests: XCTestCase {

    var viewModel: DailyViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = DailyViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }
    
    func testDailyTimeSeriesModelCreation() {
        let timeSeriesModel = loadJson(fileName: "DailySampleIBM")
        XCTAssertNotNil(timeSeriesModel, "Failed to initialize DailyTimeSeriesModel")
    }
    
    func testDailyTimeSeriesModelDateSortingDescending() {
        let timeSeriesModel = loadJson(fileName: "DailySampleIBM")
        let timeSeriesDailyModelDict = timeSeriesModel?.getTimeSeriesDict(isDailySeries: true) ?? [:]
        XCTAssertNotNil(timeSeriesDailyModelDict, "Failed to initialize DailyTimeSeriesModel")
        
        viewModel?.setTimeSeriesModelDictArray(timeSeriesModelDictArray: [timeSeriesDailyModelDict])
        viewModel?.sortDailyTimeSeriesBasedOnDateDescending(dailyTimeSeries: timeSeriesDailyModelDict)
        
        XCTAssertEqual(viewModel?.getSortedTimeSeriesList().first?[0].key, "2021-03-29", "Date descending sorting failing.")
    }
    
    func testIfTwoSymbolsDataGenerated() {
        let timeSeriesModelIBM = loadJson(fileName: "DailySampleIBM")
        let timeSeriesModelSHOP = loadJson(fileName: "DailySampleSHOP")
        let timeSeriesDailyModelIBMDict = timeSeriesModelIBM?.getTimeSeriesDict(isDailySeries: true) ?? [:]
        let timeSeriesDailyModelSHOPDict = timeSeriesModelSHOP?.getTimeSeriesDict(isDailySeries: true) ?? [:]
        viewModel?.sortDailyTimeSeriesBasedOnDateDescending(dailyTimeSeries: timeSeriesDailyModelIBMDict)
        viewModel?.sortDailyTimeSeriesBasedOnDateDescending(dailyTimeSeries: timeSeriesDailyModelSHOPDict)
        
        XCTAssertEqual(viewModel?.getSortedTimeSeriesList().count, 2, "Two symbols data not generated")
    }
    
    func testRemoveAllSymbolsMethod() {
        let timeSeriesModelIBM = loadJson(fileName: "DailySampleIBM")
        let timeSeriesModelSHOP = loadJson(fileName: "DailySampleSHOP")
        let timeSeriesDailyModelIBMDict = timeSeriesModelIBM?.getTimeSeriesDict(isDailySeries: true) ?? [:]
        let timeSeriesDailyModelSHOPDict = timeSeriesModelSHOP?.getTimeSeriesDict(isDailySeries: true) ?? [:]
        viewModel?.sortDailyTimeSeriesBasedOnDateDescending(dailyTimeSeries: timeSeriesDailyModelIBMDict)
        viewModel?.sortDailyTimeSeriesBasedOnDateDescending(dailyTimeSeries: timeSeriesDailyModelSHOPDict)
        viewModel?.removeAllElements()
        
        XCTAssertEqual(viewModel?.getSortedTimeSeriesList().count, 0, "RemoveAll method is not working.")
    }
    
    func testAPIFailForMaximumUsages() {
        let timeSeriesFail = loadJson(fileName: "APIFail")
        XCTAssertTrue(!(timeSeriesFail?.note?.isEmpty)!, "API maximum usages case not handled.")
    }
}
