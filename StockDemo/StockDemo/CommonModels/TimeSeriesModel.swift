//
//  IntradayModel.swift
//  StockDemo
//
//  Created by Rahul Dange on 29/03/21.
//

enum TimeInterval: String {
    case oneMin = "1min"
    case fiveMin = "5min"
    case fifteenMin = "15min"
    case thirtyMin = "30min"
    case sixtyMin = "60min"
}

// MARK: - TimeSeriesModel
struct TimeSeriesModel: Decodable {
    let timeSeries1Min: [String: EquityInfoModel]?
    let timeSeries5Min: [String: EquityInfoModel]?
    let timeSeries15Min: [String: EquityInfoModel]?
    let timeSeries30Min: [String: EquityInfoModel]?
    let timeSeries60Min: [String: EquityInfoModel]?
    let timeSeriesDaily: [String: EquityInfoModel]?

    enum CodingKeys: String, CodingKey {
        case timeSeries1Min = "Time Series (1min)"
        case timeSeries5Min = "Time Series (5min)"
        case timeSeries15Min = "Time Series (15min)"
        case timeSeries30Min = "Time Series (30min)"
        case timeSeries60Min = "Time Series (60min)"
        case timeSeriesDaily = "Time Series (Daily)"
    }
    
    func getTimeSeriesDict() -> [String: EquityInfoModel] {
        let currentTimeInterval = TimeInterval(rawValue: AppConstants.API.interval)
        var requiredTimeSeries:  [String: EquityInfoModel] = [:]
        
        switch currentTimeInterval {
        case .oneMin:
            requiredTimeSeries = timeSeries1Min ?? [:]
        case .fiveMin:
            requiredTimeSeries = timeSeries5Min ?? [:]
        case .fifteenMin:
            requiredTimeSeries = timeSeries15Min ?? [:]
        case .thirtyMin:
            requiredTimeSeries = timeSeries30Min ?? [:]
        case .sixtyMin:
            requiredTimeSeries = timeSeries60Min ?? [:]
        default:
            requiredTimeSeries = timeSeriesDaily ?? [:]
        }
        
        return requiredTimeSeries
    }
}

// MARK: - TimeSeries60Min
struct EquityInfoModel: Decodable {
    let open: String
    let high: String
    let low: String

    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case high = "2. high"
        case low = "3. low"
    }
}

