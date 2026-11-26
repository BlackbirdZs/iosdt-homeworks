//
//  KeychainServiceProtocol.swift
//  DocApp
//
//  Created by Anton Kruglov on 26.11.2026.
//

import Foundation
import UIKit

protocol KeychainServiceProtocol {
    func getPassword() -> String?
    func savePassword(_ password: String)
    func updatePassword(_ password: String)
}
