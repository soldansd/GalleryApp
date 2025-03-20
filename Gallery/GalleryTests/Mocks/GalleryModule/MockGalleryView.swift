//
//  MockGalleryView.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

@testable import Gallery

final class MockGalleryView: GalleryViewProtocol {
    
    var updateCalled = false
    var reloadCalled = false
    
    func reload() {
        reloadCalled = true
    }
    
    func update() {
        updateCalled = true
    }
}
