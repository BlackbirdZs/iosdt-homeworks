//
//  Parcer.swift
//  Navigation
//
//  Created by Anton Kruglov on 12.11.2026.
//

import Foundation

class Parcer {
    func parce(data: Data) -> JsonUser? {
        do {
            let recievedData = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
            guard let userId = recievedData?["userId"] as? Int else { return nil }
            guard let id = recievedData?["id"] as? Int else { return nil }
            guard let title = recievedData?["title"] as? String else { return nil }
            guard let completed = recievedData?["completed"] as? Bool else { return nil }

            let user = JsonUser(userId: userId, id: id, title: title, completed: completed)
            return user
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
