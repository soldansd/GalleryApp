//
//  GalleryBuilderTests.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import XCTest
@testable import Gallery

final class GalleryBuilderTests: XCTestCase {
    
    var builder: GalleryBuilder!
    var mockRouter: MockGalleryRouter!
    
    override func setUp() {
        mockRouter = MockGalleryRouter()
        builder = GalleryBuilder(router: mockRouter)
    }
    
    override func tearDown() {
        builder = nil
        mockRouter = nil
    }
    
    func testAssemblyReturnsGalleryViewController() {
        let viewController = builder.assembly()
        
        XCTAssertTrue(viewController is GalleryViewController)
    }
}
