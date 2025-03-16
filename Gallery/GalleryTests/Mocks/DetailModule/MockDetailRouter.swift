//
//  MockDetailRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 16/03/2025.
//

@testable import Gallery

class MockDetailRouter: DetailRouterProtocol {
    
    var openDetailScreenCalled = false
    var closeDetailScreenCalled = false
    
    func openDetailScreen(photo: Gallery.Photo) {
        openDetailScreenCalled = true
    }
    
    func closeDetailScreen() {
        closeDetailScreenCalled = true
    }
}
