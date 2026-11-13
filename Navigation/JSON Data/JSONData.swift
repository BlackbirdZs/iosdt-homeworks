//
//  JSONData.swift
//  Navigation
//
//  Created by Anton Kruglov on 12.11.2026.
//

import Foundation

struct JsonUser: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
