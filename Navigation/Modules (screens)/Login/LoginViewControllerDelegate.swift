//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Anton Kruglov on 29.09.2026.
//

import Foundation

protocol LoginViewControllerDelegate: AnyObject {
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)

    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}
