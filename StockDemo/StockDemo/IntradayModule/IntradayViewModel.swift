//
//  IntradayViewModel.swift
//  StockDemo
//
//  Created by Rahul Dange on 29/03/21.
//

class IntradayViewModel {
    
    private var timeSeriesModelDict: [String: EquityInfoModel] = [:]
    private var allKeysSorted: [String] = []
    
    // MARK: - internal Methods -
    func getTimeSeriesModelDict() -> [String: EquityInfoModel] {
        return timeSeriesModelDict
    }
    
    func getSortedKeys() -> [String] {
        return allKeysSorted.isEmpty ? timeSeriesModelDict.keys.sorted() : allKeysSorted
    }
    
    func fetchIntradayTimeSeries(for symbol: String, completion: @escaping (_ message: String) -> ()) {
        let apiManager = APIManager()
        apiManager.getIntradayData(for: symbol) { [weak self] (timeSeriesModel, result) in
            if result == .Success {
                self?.timeSeriesModelDict = timeSeriesModel?.getTimeSeriesDict() ?? [:]
                completion("")
            } else if result == .NoInternet {
                completion(AppConstants.no_network_error_msg)
            } else{
                completion(AppConstants.server_error_msg)
            }
        }
    }
}
