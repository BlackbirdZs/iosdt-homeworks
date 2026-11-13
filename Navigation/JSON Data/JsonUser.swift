//
//  JsonUser.swift
//  Navigation
//
//  Created by Anton Kruglov on 12.11.2026.
//

import Foundation

struct JsonUser: Codable {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}
