//
//  KeyChainService.swift
//  DocApp
//
//  Created by Anton Kruglov on 26.11.2026.
//

import Foundation
import KeychainSwift

class KeyChainService: KeychainServiceProtocol {
    let keyChain = KeychainSwift()

    func getPassword() -> String? {
        return keyChain.get("password")
    }

    func savePassword(_ password: String) {
        keyChain.set(password, forKey: "password")
    }

    func updatePassword(_ password: String) {
        keyChain.delete("password")
        keyChain.set(password, forKey: "password")
    }
}
