//
//  KeychainStoreAPI.swift
//  StockDemo
//
//  Created by Rahul Dange on 31/03/21.
//

import Foundation
import Security

/// shared instance
private let sharedInstance = KeychainStoreAPI()

class KeychainStoreAPI {
    
    class var shared: KeychainStoreAPI {
        return sharedInstance
    }
    
    // MARK: - internal methods -
    /// This function updates or add key-value to keychain database
    /// - parameters:
    ///     - value: value as String
    ///     - key: key as String
    /// - throws: KeychainStoreError
    ///
    func setValue(_ value: String, for key: String) throws {
        /// encode the value
        guard let encodedValue = value.data(using: .utf8) else {
            throw KeychainStoreError.stringConversionError
        }
        
        /// create a query to search for key in keychain database
        var searchQuery: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        /// search keychain database with the searchQuery
        var status = SecItemCopyMatching(searchQuery as CFDictionary, nil)
        switch status {
        case errSecSuccess:
            /// key found in keychain DB now update the value
            var valueDict: [String: Any] = [:]
            valueDict[String(kSecValueData)] = encodedValue
            status = SecItemUpdate(searchQuery as CFDictionary,
                                   valueDict as CFDictionary)
            
        case errSecItemNotFound:
            /// key not found in keychain DB now add new key value
            /// key already added in th searchQuery, now add value in searchQuery
            searchQuery[String(kSecValueData)] = encodedValue
            status = SecItemAdd(searchQuery as CFDictionary, nil)
        
        default:
            throw getReadableError(from: status)
        }
        
        /// if status is not success then throw readable error
        if status != errSecSuccess {
            throw getReadableError(from: status)
        }
    }
    
    /// This function gets value for given key from keychain database
    /// - parameters:
    ///     - key: key for which value to be searched
    /// - throws: KeychainStoreError
    ///
    func getValue(for key: String) throws -> String? {
        /// create search query with attributes
        let searchQuery: [String: Any] = [
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnData as String: kCFBooleanTrue as Any,
            kSecAttrAccount as String: key,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        /// fire search query on Keychain Database and get the result in searchQueryResult
        var searchQueryResult: AnyObject?
        let status = SecItemCopyMatching(searchQuery as CFDictionary, &searchQueryResult)
        
        switch status {
        case errSecSuccess:
            /// item found in keychain database
            guard let valueData = searchQueryResult as? Data,
                  let value = String(data: valueData, encoding: .utf8) else {
                throw KeychainStoreError.dataConversionError
            }
            return value
            
        case errSecItemNotFound:
            return nil
        default:
            throw getReadableError(from: status)
        }
    }
    
    /// This function deletes key-value from keychain database
    /// - parameters:
    ///     - key: key for which value to be deleted
    /// - throws: KeychainStoreError
    ///
    func deleteValue(for key: String) throws {
        /// create search query with attributes
        let searchQuery: [String: Any] = [
            kSecAttrAccount as String: key,
            kSecClass as String: kSecClassGenericPassword
        ]
        
        /// delete key from Keychain database
        let status = SecItemDelete(searchQuery as CFDictionary)
        
        guard status == errSecSuccess else {
            throw getReadableError(from: status)
        }
    }
    
    // MARK: - private methods -
    private func getReadableError(from status: OSStatus) -> KeychainStoreError {
        let errMsg = SecCopyErrorMessageString(status, nil) as String? ?? NSLocalizedString("Unhandled Error", comment: "")
        return KeychainStoreError.error(message: errMsg)
    }
}

enum KeychainStoreError: Error, LocalizedError {
    case dataConversionError
    case stringConversionError
    case error(message: String)
    
    var errorDescription: String? {
        switch self {
        case .dataConversionError:
            return NSLocalizedString(AppConstants.data_to_string_conversion_error, comment: "")
        case .stringConversionError:
            return NSLocalizedString(AppConstants.string_to_data_conversion_error, comment: "")
        case .error(let message):
            return NSLocalizedString(message, comment: "")
        }
    }
}
