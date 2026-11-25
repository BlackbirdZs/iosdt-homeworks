//
//  TextPicker.swift
//  DocApp
//
//  Created by Anton Kruglov on 25.11.2026.
//

import Foundation
import UIKit

final class TextPicker {
    static let shared = TextPicker()

    private init() {}

    func showMessage(in viewController: UIViewController, message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true)
    }

    func addFolderAlert(in vievController: UIViewController, completion: @escaping ((_ text: String) -> Void)) {
        let alert = UIAlertController(title: "New folder will be created", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Add folder name here..."
        }
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            if let text = alert.textFields?[0].text {
                completion(text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        vievController.present(alert, animated: true)
    }
}
