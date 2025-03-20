//
//  DetailRouterTests.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import XCTest
@testable import Gallery

final class DetailRouterTests: XCTestCase {

    var mockNavigationController: MockNavigationController!
    var mockPhotoManager: MockPhotoManager!
    var router: DetailRouter!
    
    override func setUp() {
        mockNavigationController = MockNavigationController()
        mockPhotoManager = MockPhotoManager()
        router = DetailRouter(
            navigationController: mockNavigationController,
            photoManager: mockPhotoManager,
            observedNotification: .photosDidUpdate
        )
    }
    
    override func tearDown() {
        router = nil
        mockNavigationController = nil
    }
    
    func testOpenDetailScreenPushesDetailViewController() {
        
        router.openDetailScreen(initialPhoto: MockPhoto.photo, photos: [MockPhoto.photo])
        
        XCTAssertTrue(mockNavigationController.pushedViewController is DetailViewController)
    }
    
    func testCloseDetailScreenPopsViewController() {
        
        router.openDetailScreen(initialPhoto: MockPhoto.photo, photos: [MockPhoto.photo])
        router.closeDetailScreen()
        
        XCTAssertNil(mockNavigationController.pushedViewController)
    }
}
