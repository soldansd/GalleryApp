//
//  CacheManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class CacheManager {
    
    static let shared = CacheManager()
    
    private let imageCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    func getImageData(forKey key: String) -> Data? {
        return imageCache.object(forKey: key as NSString) as Data?
    }
    
    func saveImageData(_ data: Data, forKey key: String) {
        imageCache.setObject(data as NSData, forKey: key as NSString)
    }
    
    func removeImageData(forKey key: String) {
        imageCache.removeObject(forKey: key as NSString)
    }
    
    func clearCache() {
        imageCache.removeAllObjects()
    }
}
