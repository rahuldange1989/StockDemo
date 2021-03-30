//
//  KeychainStoreAPITests.swift
//  StockDemoTests
//
//  Created by Rahul Dange on 31/03/21.
//

import XCTest
@testable import StockDemo

class KeychainStoreAPITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testKeychainAddFunction() {
        do {
            try KeychainStoreAPI.shared.setValue("password", for: "user1")
            try KeychainStoreAPI.shared.deleteValue(for: "user1")
        } catch {
            XCTAssertFalse(error.localizedDescription.isEmpty, "keychain add function not working")
        }
    }
    
    func testKeychainUpdateFunction() {
        do {
            try KeychainStoreAPI.shared.setValue("password", for: "user1")
            try KeychainStoreAPI.shared.setValue("password1", for: "user1")
            let value = try KeychainStoreAPI.shared.getValue(for: "user1")
            try KeychainStoreAPI.shared.deleteValue(for: "user1")
            XCTAssertEqual(value, "password1", "keychain update function not working")
        } catch {
            XCTAssertFalse(error.localizedDescription.isEmpty, "keychain update function not working")
        }
    }
    
    func testKeychainGetFunction() {
        do {
            try KeychainStoreAPI.shared.setValue("password", for: "user1")
            let value = try KeychainStoreAPI.shared.getValue(for: "user1")
            try KeychainStoreAPI.shared.deleteValue(for: "user1")
            XCTAssertEqual(value, "password", "keychain update function not working")
        } catch {
            XCTAssertFalse(error.localizedDescription.isEmpty, "keychain get function not working")
        }
    }
    
    func testKeychainDeleteFunction() {
        do {
            try KeychainStoreAPI.shared.setValue("password", for: "user1")
            try KeychainStoreAPI.shared.deleteValue(for: "user1")
        } catch {
            XCTAssertFalse(error.localizedDescription.isEmpty, "keychain delete function not working")
        }
    }
}
