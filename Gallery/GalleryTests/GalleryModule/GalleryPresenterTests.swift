//
//  GalleryPresenterTests.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import XCTest
@testable import Gallery

final class GalleryPresenterTests: XCTestCase {

    private var presenter: GalleryPresenter!

    private var mockRouter: MockGalleryRouter!
    private var mockPhotoManager: MockPhotoManager!
    private var mockView: MockGalleryView!
    
    override func setUp() {
        mockRouter = MockGalleryRouter()
        mockPhotoManager = MockPhotoManager()
        mockView = MockGalleryView()
        
        presenter = GalleryPresenter(
            router: mockRouter,
            photoManager: mockPhotoManager,
            observedNotification: .photosDidUpdate
        )
        presenter.view = mockView
    }
    
    override func tearDown() {
        presenter = nil
        mockRouter = nil
        mockView = nil
        mockPhotoManager = nil
    }
    
    func testLoadNextPage() {
        mockPhotoManager.loadNextPageCalled = false
        
        presenter.loadNextPage()
        
        XCTAssertTrue(mockPhotoManager.loadNextPageCalled)
    }

    func testOpenDetailScreen() {
        let photo = MockPhoto.photo
        
        presenter.openDetailScreen(for: photo, photos: [photo])
        
        XCTAssertTrue(mockRouter.openDetailScreenCalled)
        XCTAssertEqual(photo.id, MockPhoto.photo.id)
    }
    
    func testGetImageSuccess() {
        let expectation = expectation(description: "Waiting for image fetching")
        let photo = MockPhoto.photo
        let expectedData = Data("data".utf8)
        mockPhotoManager.getImageResult = .success(expectedData)
        
        var receivedData: Data?
        
        presenter.getImage(for: photo) { data in
            receivedData = data
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(receivedData, expectedData)
    }
    
    func testGetImageFailure() {
        let expectation = expectation(description: "Waiting for image fetching")
        let photo = MockPhoto.photo
        mockPhotoManager.getImageResult = .failure(NetworkError.invalidURL)
        
        var receivedData: Data? = Data()
        
        presenter.getImage(for: photo) { data in
            receivedData = data
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertNil(receivedData)
    }
}
