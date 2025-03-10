//
//  CacheManagerProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

protocol CacheManagerProtocol {
    
    func getData(forKey key: String) -> Data?
    func saveData(_ data: Data, forKey key: String)
    func removeData(forKey key: String)
    func clearCache()
}
