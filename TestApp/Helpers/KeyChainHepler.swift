//
//  KeyChainHepler.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 7.10.2022.
//

import Foundation
import Combine

final class KeyChainHepler {
    static let shared = KeyChainHepler()

    private init() { }

}

extension KeyChainHepler: PasswordStoreServiceProtocol {
    func savePassword(password: String) -> Future<Void, KeyChainErrors> {
        return Future { promise in
            let query: [String: AnyObject] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticValues.keychainServiceName.rawValue as AnyObject,
                kSecValueData as String: password.data(using: .utf8) as AnyObject,
            ]

            let status = SecItemAdd(query as CFDictionary, nil)

            switch status {
            case errSecSuccess:
                promise(.success(()))
            case errSecDuplicateItem:
                promise(.failure(KeyChainErrors.duplicateEntry))
            default:
                promise(.failure(KeyChainErrors.unkown))
            }
        }
    }
    
    func getPassword() -> Future<String, KeyChainErrors> {
        return Future { promise in
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticValues.keychainServiceName.rawValue as AnyObject,
                kSecReturnData as String: kCFBooleanTrue,
                kSecMatchLimit as String: kSecMatchLimitOne
            ] as CFDictionary

            var result: AnyObject?
            SecItemCopyMatching(query as CFDictionary, &result)
            
            guard let result = result as? Data else { return promise(.failure(KeyChainErrors.unkown)) }
            let password = String(decoding: result, as: UTF8.self)
            promise(.success(password))
        }
    }
    
    func updatePassword(newPassword: String) -> Future<Void, KeyChainErrors> {
        return Future { promise in
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticValues.keychainServiceName.rawValue as AnyObject
            ] as CFDictionary
            
            let attributesToUpdate = [
                kSecValueData as String: newPassword.data(using: .utf8) as AnyObject,
            ] as CFDictionary

            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            switch status {
            case errSecSuccess:
                promise(.success(()))
            case errSecDuplicateItem:
                promise(.failure(KeyChainErrors.duplicateEntry))
            default:
                promise(.failure(KeyChainErrors.unkown))
            }
        }
    }
    
    func deletePassword() -> Future<Void, KeyChainErrors> {
        return Future { promise in
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: StaticValues.keychainServiceName.rawValue as AnyObject
            ] as CFDictionary
            
            let status = SecItemDelete(query as CFDictionary)
            
            switch status {
            case errSecSuccess:
                promise(.success(()))
            case errSecDuplicateItem:
                promise(.failure(KeyChainErrors.duplicateEntry))
            default:
                promise(.failure(KeyChainErrors.unkown))
            }
        }
    }
}
