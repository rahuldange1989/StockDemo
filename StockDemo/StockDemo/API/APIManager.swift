//
//  APIManager.swift
//  StockDemo
//
//  Created by Rahul Dange on 29/03/21.
//

import Foundation

enum RequestResult {
    case Success
    case Fail
    case NoInternet
    case TimeOut
    case Cancel
    case DataError
    case SessionExpired
    case Outdated
    case InvalidLogin
    case ServerError
    case CommonKeyFailed
}

/// APIManager class to handle APIs
class APIManager {
    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ result: RequestResult?) -> Void) {
        if NetworkReachability.sharedInstance.isNetworkAvailable() {
            guard let url = URL(string: urlString) else {
                print("Error: Cannot create URL from string")
                return
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard error == nil else {
                    print("Error calling api")
                    return completion(nil, .DataError)
                }
                guard let responseData = data else {
                    print("Data is nil")
                    return completion(nil, .DataError)
                }
                completion(responseData, .Success)
            }
            task.resume()
        } else {
            completion(nil, .NoInternet)
        }
    }
}

extension APIManager {
    /// This function downloads Intradat data from given Symbol
    /// with provided interval and API key
    /// - parameters:
    ///     - symbol: symbol for which data to be downloaded
    ///     - completion: completion block which returns `TimeSeriesModel` from API and result of API call
    ///
    func getIntradayData(for symbol: String, completion: @escaping (_ timeSeriesModel: TimeSeriesModel?, _ result: RequestResult?) -> Void) {
        let intradayUrl = String(format: AppConstants.API.time_series_intraday_url,
                                 symbol,
                                 AppConstants.API.interval,
                                 AppConstants.API.outputsize,
                                 AppConstants.API.api_key_alpha_vantage)

        /// API call to get and convert data
        self.getJSONFromURL(urlString: AppConstants.API.server_url + intradayUrl) { (data, result) in
            guard let data = data else {
                print("Failed to get data")
                return completion(nil, result)
            }
            self.createTimeSeriesModel(with: data, completion: { (searchModels, error) in
                return completion(searchModels, error)
            })
        }
    }
    
    /// This function downloads Daily data from given Symbol
    /// with provided interval and API key
    /// - parameters:
    ///     - symbol: symbol for which data to be downloaded
    ///     - completion: completion block which returns `TimeSeriesModel` from API and result of API call
    ///
    func getDailyData(for symbol: String, completion: @escaping (_ timeSeriesModel: TimeSeriesModel?, _ result: RequestResult?) -> Void) {
        let dailyUrl = String(format: AppConstants.API.time_series_daily_adjusted_url,
                                 symbol,
                                 AppConstants.API.outputsize,
                                 AppConstants.API.api_key_alpha_vantage)

        /// API call to get and convert data
        self.getJSONFromURL(urlString: AppConstants.API.server_url + dailyUrl) { (data, result) in
            guard let data = data else {
                print("Failed to get data")
                return completion(nil, result)
            }
            self.createTimeSeriesModel(with: data, completion: { (searchModels, error) in
                return completion(searchModels, error)
            })
        }
    }
    
    private func createTimeSeriesModel(with json: Data, completion: @escaping (_ data: TimeSeriesModel?, _ result: RequestResult?) -> Void) {
        do {
            let decoder = JSONDecoder()
            let timeSeriesModel = try decoder.decode(TimeSeriesModel.self, from: json)
            return completion(timeSeriesModel, .Success)
        } catch let error {
            print("Error creating time series model from JSON. \(error.localizedDescription)")
            return completion(nil, .DataError)
        }
    }
}
