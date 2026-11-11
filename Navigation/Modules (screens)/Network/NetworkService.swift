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
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code: \(httpResponse.statusCode)")
                print("Headers: \(httpResponse.allHeaderFields)")
            }
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Data: \(jsonString)")
            }
        }
        task.resume()
    }
}

//If there is no intternet - i get the error -1001 (The request timed out) or -1009 (The Internet connection appears to be offline).
