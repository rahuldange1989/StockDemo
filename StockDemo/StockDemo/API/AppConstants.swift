//
//  AppConstants.swift
//  StockDemo
//
//  Created by Rahul Dange on 28/03/21.
//

import UIKit

/// AppConstants struct includes all constants required in project
struct AppConstants {
    
    struct API {
        static let api_key_alpha_vantage = "78TV77XPOXDOJC4Z"
        static let server_url = "https://www.alphavantage.co/query?function="
        static let time_series_intraday_url = "TIME_SERIES_INTRADAY&symbol=%@&interval=%@&apikey=%@"
        static let time_series_daily_adjusted_url = "TIME_SERIES_DAILY_ADJUSTED&symbol=%@&apikey=%@"
    }

    static let incoming_intraday_date_format = "YYYY-MM-dd HH:mm:ss"
    static let incoming_daily_date_format = "YYYY-MM-dd"
    static let required_date_format = "dd/MM/YYYY"
    static let required_time_format = "HH:mm"
    static let theme_color = UIColor(red: 211, green: 17, blue: 69)
    
    // -- Constant String Messages
    static let server_error_msg = "Unable to connect to the server.\nPlease try again later."
    static let no_network_error_MSG = "You are currently offline. Please connect to internet."
}
