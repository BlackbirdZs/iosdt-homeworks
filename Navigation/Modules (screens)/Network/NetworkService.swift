//
//  NetworkService.swift
//  Navigation
//
//  Created by Anton Kruglov on 11.11.2026.
//

import Foundation

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        let url: URL

        switch configuration {
        case let .people(link): url = link
        case let .planets(link): url = link
        case let .starships(link): url = link
        }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Error code: \(httpResponse.statusCode)")
                return
            }
            guard let data else {
                print("No data")
                return
            }
        }
    }
}
