//
//  AppDelegate.swift
//  StockDemo
//
//  Created by Rahul Dange on 26/03/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        /// Initialize Network Manager Reachability
        NetworkReachability.sharedInstance.initialize()
        
        /// Change appearance of Navigation bar
        UINavigationBar.appearance().barTintColor = AppConstants.theme_color
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        /// Change appearance of tabbar
        UITabBar.appearance().barTintColor = AppConstants.theme_color
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().isTranslucent = false
        
        /// change appearance of UISegmentControl
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        /// retrieve settings data from UserDefaults and Keychain
        retrieveSettingsData()
        
        return true
    }
    
    // MARK: - private methods -
    private func retrieveSettingsData() {
        /// retrieve interval and outputsize from UserDefaults
        guard let interval = UserDefaults.standard.value(forKey: AppConstants.interval_user_defaults_key) as? String,
              let outputSize = UserDefaults.standard.value(forKey: AppConstants.outputsize_user_defaults_key) as? String else {
            return
        }
        AppConstants.API.interval = interval
        AppConstants.API.outputsize = outputSize
        
        /// retrieve api key from Keychain Database
        do {
            let apikey = try KeychainStoreAPI.shared.getValue(for: AppConstants.api_key_keychain)
            if let apikey = apikey {
                AppConstants.API.api_key_alpha_vantage = apikey
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

