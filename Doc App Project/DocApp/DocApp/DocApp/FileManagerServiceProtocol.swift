//
//  FileManagerServiceProtocol.swift
//  DocApp
//
//  Created by Anton Kruglov on 25.11.2026.
//

import Foundation

protocol FileManagerServiceProtocol {
    var path: String { get }
    var title: String { get }
    var contentsOfDirectory: [String] { get }
    func createDirectory(with name: String)
    func createFile(with data: Data, name: String)
    func removeContent(at index: Int)
    func isItemInFolder(index: Int) -> Bool
}
