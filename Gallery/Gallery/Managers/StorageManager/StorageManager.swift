//
//  StorageManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class StorageManager: StorageManagerProtocol {
    
    // MARK: - Properties
    
    static let shared = StorageManager()
    
    private let fileManager = FileManager.default
    
    private let url: URL
    
    // MARK: - Init
    
    private init() {
        url = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("ImageStorage")
        
        createDirectoryIfNeeded()
    }
    
    // MARK: - Methods
    
    func saveData(_ data: Data, forKey key: String) throws {
        let filePath = url.appendingPathComponent(key)
        try data.write(to: filePath)
    }
    
    func getData(forKey key: String) -> Data? {
        let filePath = url.appendingPathComponent(key)
        return try? Data(contentsOf: filePath)
    }
    
    func removeData(forKey key: String) throws {
        let filePath = url.appendingPathComponent(key)
        try fileManager.removeItem(at: filePath)
    }
    
    private func createDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Failed to create directory: \(error)")
            }
        }
    }
}
