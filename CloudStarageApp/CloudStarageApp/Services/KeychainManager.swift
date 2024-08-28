//
//  KeychainManager.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 26.08.2024.
//

import Security
import Foundation

enum KeychainError: Error {
    case duplicated
    case unoknow(OSStatus)
}

protocol KeychainProtocol {
    func save(_ value: String, forKey key: String) throws
    func get(forKey key: String) throws -> String?
    func delete(forKey key: String) throws
}

final class KeychainManager: KeychainProtocol {
    
    static let shared = KeychainManager()
    
    private init() {}
    
    func save(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        _ = SecItemAdd(query as CFDictionary, nil)
        //        guard status != errSecDuplicateItem else {
        //            throw KeychainError.duplicated
        //        }
        //        guard status == errSecSuccess else {
        //            throw KeychainError.unoknow(status)
        //        }
    }
    
    func get(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }

    func delete(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            throw KeychainError.unoknow(status)
        }
    }
}

