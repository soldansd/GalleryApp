//
//  CacheManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class CacheManager: CacheManagerProtocol {
    
    static let shared = CacheManager()
    
    private let imageCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getData(forKey key: String) -> Data? {
        return imageCache.object(forKey: key as NSString) as Data?
    }
    
    func saveData(_ data: Data, forKey key: String) {
        imageCache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func removeData(forKey key: String) {
        imageCache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
