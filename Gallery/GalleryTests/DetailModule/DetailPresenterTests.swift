//
//  DetailPresenterTests.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import XCTest
@testable import Gallery

final class DetailPresenterTests: XCTestCase {
    
    var presenter: DetailPresenter!
    var mockView: MockDetailView!
    var mockRouter: MockDetailRouter!
    var mockPhotoManager: MockPhotoManager!
    var mockPhoto: Photo!
    
    override func setUp() {
        mockView = MockDetailView()
        mockRouter = MockDetailRouter()
        mockPhotoManager = MockPhotoManager()
        mockPhoto = MockPhoto.photo
        
        presenter = DetailPresenter(
            router: mockRouter,
            photoManager: mockPhotoManager,
            initialPhoto: mockPhoto,
            photos: [mockPhoto],
            observedNotification: .fetchedPhotosDidUpdate
        )
        presenter.view = mockView
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        mockRouter = nil
        mockPhotoManager = nil
        mockPhoto = nil
    }
    
    func testLoadNextPage() {
        mockPhotoManager.loadNextPageCalled = false
        
        presenter.loadNextPage()
        
        XCTAssertTrue(mockPhotoManager.loadNextPageCalled)
    }
    
    func testUpdateLikeStatus() {
        mockPhotoManager.updateLikeStatusCalled = false
        
        presenter.updateLikeStatus(photo: mockPhoto)
        
        XCTAssertTrue(mockPhotoManager.updateLikeStatusCalled)
    }
    
    func testCloseDetailScreen() {
        mockRouter.closeDetailScreenCalled = false
        
        presenter.closeDetailScreen()
        
        XCTAssertTrue(mockRouter.closeDetailScreenCalled)
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
