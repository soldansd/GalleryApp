//
//  MockDetailRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 16/03/2025.
//

@testable import Gallery

final class MockDetailRouter: DetailRouterProtocol {
        
    var openDetailScreenCalled = false
    var closeDetailScreenCalled = false
    
    func openDetailScreen(initialPhoto: Photo, photos: [Photo]) {
        openDetailScreenCalled = true
    }
    
    func closeDetailScreen() {
        closeDetailScreenCalled = true
    }
}
