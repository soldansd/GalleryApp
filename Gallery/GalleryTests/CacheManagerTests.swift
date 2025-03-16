//
//  CacheManagerTests.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import XCTest
@testable import Gallery

final class CacheManagerTests: XCTestCase {
    
    private var cache = CacheManager.shared

    override func setUp() {
        cache.clearCache()
    }

    func testSaveAndGetData() {
        let key = "key"
        let data = Data("data".utf8)
        
        cache.saveData(data, forKey: key)
        
        XCTAssertEqual(cache.getData(forKey: key), data)
    }
    
    func testRemoveData() {
        let key = "key"
        let data = Data("data".utf8)
        
        cache.saveData(data, forKey: key)
        cache.removeData(forKey: key)
        
        XCTAssertNil(cache.getData(forKey: key))
    }
    
    func testClearCache() {
        let key1 = "key1"
        let data1 = Data("data1".utf8)
        let key2 = "key2"
        let data2 = Data("data2".utf8)
        
        cache.saveData(data1, forKey: key1)
        cache.saveData(data2, forKey: key2)
        cache.clearCache()
        
        XCTAssertNil(cache.getData(forKey: key1))
        XCTAssertNil(cache.getData(forKey: key2))
    }
}
