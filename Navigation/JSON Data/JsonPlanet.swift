//
//  JsonPlanet.swift
//  Navigation
//
//  Created by Anton Kruglov on 13.11.2026.
//

import Foundation

struct JsonPlanet: Codable {
    var name: String
    var rotationPeriod: Int 
    var orbitalPeriod: Int
    var diameter: Int
    var climate: String
    var gravity: String
    var terrain: String
    var surfaceWater: Int
    var population: Int
    var residents: [URL]
    var films: [URL]
    var created: String
    var edited: String
    var url: URL

    enum codingKeys: String, CodingKey {
        case orbitalPeriod = "orbital_period"
        case surfaceWater = "surface_water"
    }
}
