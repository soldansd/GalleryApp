//
//  DetailBuilderTests.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import XCTest
@testable import Gallery

final class DetailBuilderTests: XCTestCase {

    var builder: DetailBuilder!
    var mockRouter: MockDetailRouter!
    var mockPhotoManager: MockPhotoManager!
    
    override func setUp() {
        mockRouter = MockDetailRouter()
        mockPhotoManager = MockPhotoManager()
        builder = DetailBuilder(
            router: mockRouter,
            photoManager: mockPhotoManager,
            observedNotification: .fetchedPhotosDidUpdate
        )
    }
    
    override func tearDown() {
        builder = nil
        mockPhotoManager = nil
        mockRouter = nil
    }
    
    func testAssemblyReturnsGalleryViewController() {
        let viewController = builder.assembly(initialPhoto: MockPhoto.photo, photos: [MockPhoto.photo])
        
        XCTAssertTrue(viewController is DetailViewController)
    }
}
