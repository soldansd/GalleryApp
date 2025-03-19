//
//  StorageManagerProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

protocol StorageManagerProtocol {
    func saveData(_ data: Data, forKey key: String) throws
    func getData(forKey key: String) -> Data?
    func removeData(forKey key: String) throws
    func getAllStoredFileNames() -> [String]
}
