//
//  GalleryRouterTests.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import XCTest
@testable import Gallery

final class GalleryRouterTests: XCTestCase {
    
    var mockNavigationController: MockNavigationController!
    var router: GalleryRouter!
    var mockPhotoManager: MockPhotoManager!
    
    override func setUp() {
        mockNavigationController = MockNavigationController()
        mockPhotoManager = MockPhotoManager()
        router = GalleryRouter(
            navigationController: mockNavigationController,
            photoManager: mockPhotoManager,
            observedNotification: .photosDidUpdate
        )
    }
    
    override func tearDown() {
        router = nil
        mockPhotoManager = nil
        mockNavigationController = nil
    }
    
    func testOpenGalleryScreenPushesGalleryViewController() {
        
        router.openGalleryScreen()
        
        XCTAssertTrue(mockNavigationController.pushedViewController is GalleryViewController)
    }
    
    func testOpenDetailScreenPushesDetailViewController() {
        let photo = MockPhoto.photo
        
        router.openDetailScreen(for: photo, photos: [photo])
        
        XCTAssertTrue(mockNavigationController.pushedViewController is DetailViewController)
    }
}
