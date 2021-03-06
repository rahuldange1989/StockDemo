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
        static var api_key_alpha_vantage = "78TV77XPOXDOJC4Z"
        static var interval = "5min"
        static var outputsize = "compact"
        static let server_url = "https://www.alphavantage.co/query?function="
        static let time_series_intraday_url = "TIME_SERIES_INTRADAY&symbol=%@&interval=%@&outputsize=%@&apikey=%@"
        static let time_series_daily_adjusted_url = "TIME_SERIES_DAILY_ADJUSTED&symbol=%@&outputsize=%@&apikey=%@"
    }

    static let incoming_intraday_date_format = "YYYY-MM-dd HH:mm:ss"
    static let incoming_daily_date_format = "YYYY-MM-dd"
    static let required_date_format = "dd/MM/YYYY"
    static let required_time_format = "HH:mm"
    static let theme_color = UIColor(red: 211, green: 17, blue: 69)
    static let interval_user_defaults_key = "interval"
    static let outputsize_user_defaults_key = "outputsize"
    static let api_key_keychain = "apikey"
    
    // -- fonts
    static let helvetica_regular_font = UIFont(name: "HelveticaNeue-Regular", size: 15.0)
    static let helvetica_medium_font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
    
    // -- Constant String Messages
    static let server_error_msg = "Unable to connect to the server.\nPlease try again later."
    static let no_network_error_msg = "You are currently offline. Please connect to internet."
    static let sorting_option_message = "Choose sorting option"
    static let interval_option_message = "Choose interval option"
    static let maximum_symbols_error_message = "Maximum three symbols can be compared at a time"
    static let minimum_symbol_lenth_error_msg = "Minimum length for symbol is 3 characters"
    static let duplicate_symbol_error_msg = "Enter differnt symbols to compare"
    static let data_to_string_conversion_error = "data to string conversion error"
    static let string_to_data_conversion_error = "string to data conversion error"
    static let settings_data_save_success_msg = "Settings data saved successfully"
}
