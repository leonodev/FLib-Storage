//
//  KeychainKey.swift
//  FHKStorage
//
//  Created by Fredy Leon on 13/12/25.
//

import Foundation
import FLibUtils

public struct Keychain: Sendable {
    // MARK: - Closures Internos (Trabajan con Data)
    public var saveData: @Sendable (_ data: Data, _ key: String, _ requireBiometry: Bool) throws -> Void
    public var readData: @Sendable (_ key: String, _ prompt: String?) throws -> Data?
    public var delete: @Sendable (_ key: String) throws -> Void
    public var contains: @Sendable (_ key: String) -> Bool
    public var clearAll: @Sendable () throws -> Void

    public init(
        saveData: @escaping @Sendable (Data, String, Bool) throws -> Void = { _, _, _ in },
        readData: @escaping @Sendable (String, String?) throws -> Data? = { _, _ in nil },
        delete: @escaping @Sendable (String) throws -> Void = { _ in },
        contains: @escaping @Sendable (String) -> Bool = { _ in false },
        clearAll: @escaping @Sendable () throws -> Void = {}
    ) {
        self.saveData = saveData
        self.readData = readData
        self.delete = delete
        self.contains = contains
        self.clearAll = clearAll
    }

    // MARK: - Fachada Genérica (Idéntica a tu protocolo anterior)
    public func save<T: Codable & Sendable>(_ value: T, for key: String, requireBiometry: Bool = false) throws {
        let data = try JSONEncoder().encode(value)
        try saveData(data, key, requireBiometry)
    }

    public func read<T: Decodable & Sendable>(_ type: T.Type, for key: String, prompt: String? = nil) throws -> T? {
        guard let data = try readData(key, prompt) else { return nil }
        return try JSONDecoder().decode(type, from: data)
    }
}



@propertyWrapper
struct KeychainStored<T: Codable & Sendable>: Sendable {
    private let key: String
    private let storage: Keychain
    private let requireBiometry: Bool
    
    init(_ key: String, storage: Keychain, requireBiometry: Bool = false) {
        self.key = key
        self.storage = storage
        self.requireBiometry = requireBiometry
    }
    
    var wrappedValue: T? {
        get {
            // Para lectura general desde un wrapper, solemos no pasar prompt
            // a menos que sea un dato que SIEMPRE requiera la cara al leerse.
            try? storage.read(T.self, for: key, prompt: nil)
        }
        set {
            do {
                if let value = newValue {
                    // Usamos el flag configurado en el init
                    try storage.save(value, for: key, requireBiometry: requireBiometry)
                } else {
                    try storage.delete(key)
                }
            } catch {
                Logger.error("🔐 Keychain error: \(error)")
            }
        }
    }
}

@propertyWrapper
struct KeychainString: Sendable {
    private let key: String
    private let storage: Keychain
    private let requireBiometry: Bool
    
    init(_ key: String, storage: Keychain, requireBiometry: Bool = false) {
        self.key = key
        self.storage = storage
        self.requireBiometry = requireBiometry
    }
    
    var wrappedValue: String {
        get { (try? storage.read(String.self, for: key, prompt: nil)) ?? "" }
        set {
            try? storage.save(newValue, for: key, requireBiometry: requireBiometry)
        }
    }
}
