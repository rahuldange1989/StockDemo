//
//  IntradayModel.swift
//  StockDemo
//
//  Created by Rahul Dange on 29/03/21.
//

// MARK: - TimeSeriesModel
struct TimeSeriesModel: Decodable {
    let timeSeries1Min: [String: EquityInfoModel]
    let timeSeries5Min: [String: EquityInfoModel]
    let timeSeries15Min: [String: EquityInfoModel]
    let timeSeries30Min: [String: EquityInfoModel]
    let timeSeries60Min: [String: EquityInfoModel]
    let timeSeriesDaily: [String: EquityInfoModel]

    enum CodingKeys: String, CodingKey {
        case timeSeries1Min = "Time Series (1min)"
        case timeSeries5Min = "Time Series (5min)"
        case timeSeries15Min = "Time Series (15min)"
        case timeSeries30Min = "Time Series (30min)"
        case timeSeries60Min = "Time Series (60min)"
        case timeSeriesDaily = "Time Series (Daily)"
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

