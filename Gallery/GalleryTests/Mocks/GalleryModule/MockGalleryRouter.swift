//
//  MockGalleryRouter.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

@testable import Gallery

final class MockGalleryRouter: GalleryRouterProtocol {
        
    var openDetailScreenCalled = false
    var photoPassedToRouter: Photo?
    
    func openDetailScreen(for initialPhoto: Photo, photos: [Photo]) {
        openDetailScreenCalled = true
        photoPassedToRouter = initialPhoto
    }
}
