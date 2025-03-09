//
//  CacheManagerProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

protocol CacheManagerProtocol {
    
    func getImageData(forKey key: String) -> Data?
    func saveImageData(_ data: Data, forKey key: String)
    func removeImageData(forKey key: String)
    func clearCache()
}
