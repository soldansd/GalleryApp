//
//  StorageManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class StorageManager: StorageManagerProtocol {
    
    static let shared = StorageManager()
    
    private let fileManager = FileManager.default
    
    private let url: URL
    
    private init() {
        url = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("ImageStorage")
        createDirectoryIfNeeded()
        print(url)
    }
    
    func saveData(_ data: Data, forKey key: String) throws {
        let filePath = url.appendingPathComponent(key)
        do {
            try data.write(to: filePath)
        } catch {
            throw StorageManagerError.saveFailed
        }
    }
    
    func getData(forKey key: String) -> Data? {
        let filePath = url.appendingPathComponent(key)
        return try? Data(contentsOf: filePath)
    }
    
    func removeData(forKey key: String) throws {
        let filePath = url.appendingPathComponent(key)
        
        do {
            try fileManager.removeItem(at: filePath)
        } catch {
            throw StorageManagerError.removeFailed
        }
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
