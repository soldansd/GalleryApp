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
    
    override func setUp() {
        mockNavigationController = MockNavigationController()
        router = GalleryRouter(navigationController: mockNavigationController)
    }
    
    override func tearDown() {
        router = nil
        mockNavigationController = nil
    }
    
    func testOpenGalleryScreenPushesGalleryViewController() {
        
        router.openGalleryScreen()
        
        XCTAssertTrue(mockNavigationController.pushedViewController is GalleryViewController)
    }
    
    func testOpenDetailScreenPushesDetailViewController() {
        let photo = MockPhoto.photo
        
        router.openDetailScreen(for: photo)
        
        XCTAssertTrue(mockNavigationController.pushedViewController is DetailViewController)
    }
}
