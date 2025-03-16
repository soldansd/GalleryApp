//
//  MockGalleryView.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

@testable import Gallery

final class MockGalleryView: GalleryViewProtocol {
    
    var updateCalled = false
    
    func update() {
        updateCalled = true
    }
}
