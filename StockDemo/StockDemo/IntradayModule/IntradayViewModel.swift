//
//  IntradayViewModel.swift
//  StockDemo
//
//  Created by Rahul Dange on 29/03/21.
//

class IntradayViewModel {
    
    private var timeSeriesModelDict: [String: EquityInfoModel] = [:]
    private var sortedTimeSeriesValues: [(key: String, value: EquityInfoModel)] = []

    typealias SortDescriptor<Value> = (Value, Value) -> Bool
    
    // MARK: - internal Methods -
    func getSortedTimeSeriesList() -> [(key: String, value: EquityInfoModel)] {
        return sortedTimeSeriesValues
    }
    
    func fetchIntradayTimeSeries(for symbol: String, completion: @escaping (_ message: String) -> ()) {
        /// minimum length for symbol is 3 characters
        let symbolWithoutSpaces = symbol.replacingOccurrences(of: " ", with: "")
        if symbolWithoutSpaces.count < 3 {
            completion(AppConstants.minimum_symbol_lenth_error_msg)
            return
        }
        
        let apiManager = APIManager()
        apiManager.getIntradayData(for: symbolWithoutSpaces.percentageEncoding()) { [weak self] (timeSeriesModel, result) in
            if result == .Success {
                self?.timeSeriesModelDict = timeSeriesModel?.getTimeSeriesDict() ?? [:]
                self?.sortedTimeSeriesValues = self?.sortTimeSeriesModelDict(with: SortOptions.dateDescending.rawValueString()) ?? []
                completion("")
            } else if result == .NoInternet {
                completion(AppConstants.no_network_error_msg)
            } else{
                completion(AppConstants.server_error_msg)
            }
        }
    }
    
    func sortTimeSeriesModelDict(with option: String) -> [(key: String, value: EquityInfoModel)] {
        /// create sort descriptor with selected sort option
        let selectedSortDescriptor = self.getUserSelectedSortDescriptor(option: option)
        /// sort timeSeriesModelDict using selectedSortDescriptor
        sortedTimeSeriesValues = timeSeriesModelDict.sorted(by: selectedSortDescriptor)
        return sortedTimeSeriesValues
    }
    
    func setTimeSeriesModelDict(timeSeriesModelDict: [String: EquityInfoModel]) {
        self.timeSeriesModelDict = timeSeriesModelDict
    }
    
    // MARK: - Private methods
    private func getUserSelectedSortDescriptor(option: String) -> SortDescriptor<(key: String, value: EquityInfoModel)> {
        var sortDescriptor: SortDescriptor<(key: String, value: EquityInfoModel)>?
        switch SortOptions.init(rawValue: option) {
            case .dateAscending:
                sortDescriptor = { $0.key < $1.key }
            
            case .dateDescending:
                sortDescriptor = { $0.key > $1.key }
            
            case .highAscending:
                sortDescriptor = { $0.value.high < $1.value.high }
            
            case .highDescending:
                sortDescriptor = { $0.value.high > $1.value.high }
            
            case .lowAscending:
                sortDescriptor = { $0.value.low < $1.value.low }
            
            case .lowDescending:
                sortDescriptor = { $0.value.low > $1.value.low }
            
            case .openAscending:
                sortDescriptor = { $0.value.open < $1.value.open }
            
            case .openDescending:
                sortDescriptor = { $0.value.open > $1.value.open }
            
            case .none:
                sortDescriptor = { $0.key > $1.key }
        }
        return sortDescriptor!
    }
}
