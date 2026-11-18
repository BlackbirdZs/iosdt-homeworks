//
//  CodableNetworkService.swift
//  Navigation
//
//  Created by Anton Kruglov on 13.11.2026.
//

import Foundation

struct CodableNetworkService {
    static func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                let error = NSError(domain: "Network", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            guard let data else {
                let error = NSError(domain: "Network", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])
                completion(.failure(error))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
