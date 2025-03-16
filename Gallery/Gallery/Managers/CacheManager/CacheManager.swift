//
//  CacheManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class CacheManager: CacheManagerProtocol {
    
    // MARK: - Properties
    
    static let shared = CacheManager()
    
    private let cache = NSCache<NSString, NSData>()
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Methods
    
    func getData(forKey key: String) -> Data? {
        return cache.object(forKey: key as NSString) as Data?
    }
    
    func saveData(_ data: Data, forKey key: String) {
        cache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func removeData(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        cache.removeAllObjects()
    }
}
