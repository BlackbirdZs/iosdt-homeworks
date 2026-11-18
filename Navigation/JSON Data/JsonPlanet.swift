//
//  JsonPlanet.swift
//  Navigation
//
//  Created by Anton Kruglov on 13.11.2026.
//

import Foundation

struct JsonPlanet: Codable {
    var name: String
    var rotationPeriod: String
    var orbitalPeriod: String
    var diameter: String
    var climate: String
    var gravity: String
    var terrain: String
    var surfaceWater: String
    var population: String
    var residents: [String]
    var films: [String]
    var created: String
    var edited: String
    var url: String

    enum CodingKeys: String, CodingKey {
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case surfaceWater = "surface_water"
        case name, diameter, climate, gravity, terrain, population, residents, films, created, edited, url
    }
}
