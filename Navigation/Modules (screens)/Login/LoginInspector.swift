//
//  LoginInspector.swift
//  Navigation
//
//  Created by Anton Kruglov on 29.09.2026.
//

import Foundation

class LoginInspector: LoginViewControllerDelegate {
    private let checkerService = CheckerService()

    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.checkCredentials(email: email, password: password, completion: completion)
    }

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.signUp(email: email, password: password, completion: completion)
    }
}
