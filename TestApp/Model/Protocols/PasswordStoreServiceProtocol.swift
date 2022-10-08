//
//  KeyChainServiceProtocol.swift
//  TestApp
//
//  Created by Levent ÖZGÜR on 7.10.2022.
//

import Foundation
import Combine

protocol PasswordStoreServiceProtocol {
    func savePassword(password: String) -> Future<Void, KeyChainErrors>
    func getPassword() -> Future<String, KeyChainErrors>
    func updatePassword(newPassword: String) -> Future<Void, KeyChainErrors>
    func deletePassword() -> Future<Void, KeyChainErrors>
}
