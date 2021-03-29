//
//  DailyViewModel.swift
//  StockDemo
//
//  Created by Rahul Dange on 29/03/21.
//

import Foundation

class DailyViewModel {

    private var timeSeriesModelDictArray: [[String: EquityInfoModel]] = []
    private var sortedDailyTimeSeriesValues: [[(key: String, value: EquityInfoModel)]] = []
    private var symbols: [String] = []
    
    // MARK: - internal Methods -
    func getSortedTimeSeriesList() -> [[(key: String, value: EquityInfoModel)]] {
        return sortedDailyTimeSeriesValues
    }

    func getSymbols() -> [String] {
        return symbols
    }

    func setTimeSeriesModelDictArray(timeSeriesModelDictArray: [[String: EquityInfoModel]]) {
        self.timeSeriesModelDictArray = timeSeriesModelDictArray
    }
    
    func fetchDailyTimeSeries(for symbols: String, completion: @escaping (_ message: String) -> ()) {
        let symbolsWithoutSpaces = symbols.replacingOccurrences(of: " ", with: "")
        let symbolsArray = symbolsWithoutSpaces.components(separatedBy: ",")
        /// validate symbolsArray
        let msg = validateSymbols(symbolsArray: symbolsArray)
        if !msg.isEmpty {
            completion(msg)
            return
        }
        
        /// create dispatchGroup
        let dispatchGroup = DispatchGroup()
        var errorMsg = ""
        for symbol in symbolsArray {
            dispatchGroup.enter()
            let apiManager = APIManager()
            apiManager.getDailyData(for: symbol.percentageEncoding()) { [weak self] (timeSeriesModel, result) in
                if result == .Success {
                    let timeSeriesDailyModelDict = timeSeriesModel?.getTimeSeriesDict(isDailySeries: true) ?? [:]
                    if !timeSeriesDailyModelDict.isEmpty {
                        self?.timeSeriesModelDictArray.append(timeSeriesDailyModelDict)
                        self?.symbols.append(timeSeriesModel?.metaData?.symbol ?? "")
                        /// sort dailyTimeSeries based on descending date
                        self?.sortedDailyTimeSeriesValues.append(timeSeriesDailyModelDict.sorted(by: { (dict0, dict1) -> Bool in
                            dict0.key > dict1.key
                        }))
                    }
                } else if result == .NoInternet {
                    errorMsg = AppConstants.no_network_error_msg
                } else{
                    errorMsg = AppConstants.server_error_msg
                }
                dispatchGroup.leave()
            }
        }
        
        /// call completion block once all request completes
        dispatchGroup.notify(queue: .global()) {
            print(self.timeSeriesModelDictArray)
            completion(errorMsg)
        }
    }
    
    // MARK: - private methods -
    private func validateSymbols(symbolsArray: [String]) -> String {
        /// maximum symbols to comare is 3
        if symbolsArray.count > 3 {
            return AppConstants.maximum_symbols_error_message
        } else {
            var lastSymbol = ""
            for symbol in symbolsArray {
                /// each symbol should be of minimum lenght 3
                if symbol.count < 3 {
                    return AppConstants.minimum_symbol_lenth_error_msg
                }
                /// comparing symbols should be different
                if lastSymbol == symbol {
                    return AppConstants.duplicate_symbol_error_msg
                }
                lastSymbol = symbol
            }
            /// if first and last symbols are equal and total symbols are 3
            if symbolsArray.count == 3 && symbolsArray.first == symbolsArray.last {
                return AppConstants.duplicate_symbol_error_msg
            }
        }
        return ""
    }
}
