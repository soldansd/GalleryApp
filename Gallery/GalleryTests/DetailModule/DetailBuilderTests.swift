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
    
    override func setUp() {
        mockRouter = MockDetailRouter()
        builder = DetailBuilder(router: mockRouter)
    }
    
    override func tearDown() {
        builder = nil
        mockRouter = nil
    }
    
    func testAssemblyReturnsGalleryViewController() {
        let viewController = builder.assembly(photo: MockPhoto.photo)
        
        XCTAssertTrue(viewController is DetailViewController)
    }
}
