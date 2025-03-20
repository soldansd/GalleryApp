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
    var mockPhotoManager: MockPhotoManager!
    
    override func setUp() {
        mockRouter = MockGalleryRouter()
        mockPhotoManager = MockPhotoManager()
        builder = GalleryBuilder(
            router: mockRouter,
            photoManager: mockPhotoManager,
            observedNotification: .photosDidUpdate
        )
    }
    
    override func tearDown() {
        builder = nil
        mockPhotoManager = nil
        mockRouter = nil
    }
    
    func testAssemblyReturnsGalleryViewController() {
        let viewController = builder.assembly()
        
        XCTAssertTrue(viewController is GalleryViewController)
    }
}
