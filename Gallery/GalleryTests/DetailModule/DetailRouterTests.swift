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
    var router: DetailRouter!
    
    override func setUp() {
        mockNavigationController = MockNavigationController()
        router = DetailRouter(navigationController: mockNavigationController)
    }
    
    override func tearDown() {
        router = nil
        mockNavigationController = nil
    }
    
    func testOpenDetailScreenPushesDetailViewController() {
        
        router.openDetailScreen(photo: MockPhoto.photo)
        
        XCTAssertTrue(mockNavigationController.pushedViewController is DetailViewController)
    }
    
    func testCloseDetailScreenPopsViewController() {
        
        router.openDetailScreen(photo: MockPhoto.photo)
        router.closeDetailScreen()
        
        XCTAssertNil(mockNavigationController.pushedViewController)
    }
}
