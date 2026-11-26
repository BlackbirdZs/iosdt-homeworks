//
//  FileManagerService.swift
//  DocApp
//
//  Created by Anton Kruglov on 25.11.2026.
//

import Foundation
import UIKit

final class FileManagerService: FileManagerServiceProtocol {
    
    var path: String
    
    var title: String {
        return NSString(string: path).lastPathComponent
    }
    
    var contentsOfDirectory: [String] {
        return (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
    }
    
    init(path: String) {
        self.path = path
    }
    
    func createDirectory(with name: String) {
        try? FileManager.default.createDirectory(atPath: path + "/" + name, withIntermediateDirectories: true)
    }
    
    func createFile(with data: Data, name: String) {
        let filePath = path + "/" + name
        try? data.write(to: URL(fileURLWithPath: filePath))
    }

    func removeContent(at index: Int) {
        let deletionPath = path + "/" + contentsOfDirectory[index]
        try? FileManager.default.removeItem(atPath: deletionPath)
    }

    func isItemInFolder(index: Int) -> Bool {
        var objBool: ObjCBool = .init(false)
        FileManager.default.fileExists(atPath: path + "/" + contentsOfDirectory[index], isDirectory: &objBool)
        return objBool.boolValue
    }
}
