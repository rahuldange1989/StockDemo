//
//  SettingsViewModel.swift
//  StockDemo
//
//  Created by Rahul Dange on 30/03/21.
//

import Foundation

class SettingsViewModel {
    
    // MARK: - internal methods -
    func populateSettingsValue(completion: (_ apiKey: String, _ interval: String, _ outputSize: String, _ segmentIndex: Int) -> Void) {
        let apiKey = AppConstants.API.api_key_alpha_vantage
        let interval = AppConstants.API.interval
        let outputSize = AppConstants.API.outputsize
        let segmentIndex = outputSize == "compact" ? 0 : 1
        completion(apiKey, interval, outputSize, segmentIndex)
    }
    
    func saveSettings(apiKey: String, interval: String, outputSize: String, completion: (_ msg: String) -> Void) {
        /// save interval and outputSize in UserDefaults
        UserDefaults.standard.setValue(interval, forKey: AppConstants.interval_user_defaults_key)
        UserDefaults.standard.setValue(outputSize, forKey: AppConstants.outputsize_user_defaults_key)
        UserDefaults.standard.synchronize()

        /// update AppConstants for outputsize and interval
        AppConstants.API.outputsize = outputSize
        AppConstants.API.interval = interval
        
        /// save apiKey in Keychain
        do {
            try KeychainStoreAPI.shared.setValue(apiKey, for: AppConstants.api_key_keychain)
            /// update AppConstants for apikey
            AppConstants.API.api_key_alpha_vantage = apiKey
            completion("")
        } catch {
            completion(error.localizedDescription)
        }
    }
}
