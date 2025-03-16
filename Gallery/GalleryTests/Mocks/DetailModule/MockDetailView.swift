//
//  MockDetailView.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

@testable import Gallery

final class MockDetailView: DetailViewProtocol {
    
    var updateCalled = false
    
    func update() {
        updateCalled = true
    }
}
