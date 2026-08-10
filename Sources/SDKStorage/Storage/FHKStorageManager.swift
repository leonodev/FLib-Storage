//
//  FHKStorageManager.swift
//  FLibStorage
//
//  Created by fleon  on 10/8/26.
//

import Foundation

public struct FHKStorageManager: Sendable {
    
    // MARK: - UserDefaults
    public var saveUserDefaultsData: @Sendable (Data, String) async throws -> Void = { _, _ in }
    public var readUserDefaultsData: @Sendable (String) async throws -> Data? = { _ in nil }
    public var deleteUserDefaultsData: @Sendable (String) async throws -> Void = { _ in }
    
    // MARK: - Keychain
    public var saveKeychainData: @Sendable (Data, String, Bool) throws -> Void = { _, _, _ in }
    public var readKeychainData: @Sendable (String, String?) throws -> Data? = { _, _ in nil }
    public var deleteKeychainData: @Sendable (String) throws -> Void = { _ in }
    public var containsKeychainKey: @Sendable (String) -> Bool = { _ in false }
    public var clearAllKeychainData: @Sendable () throws -> Void = {}
    
    // MARK: - Sistema / Hardware
    public var isBiometryAvailableAction: @Sendable () -> Bool = { false }
    public var existsKeyAction: @Sendable (String) -> Bool = { _ in false }

    public init() {}
}
