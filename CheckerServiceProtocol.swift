//
//  CheckerService.swift
//  Navigation
//
//  Created by Anton Kruglov on 19.11.2026.
//

import Foundation

protocol CheckerServiceProtocol {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}
