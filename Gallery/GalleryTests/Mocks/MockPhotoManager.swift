//
//  MockPhotoPaginationManager.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import Foundation
@testable import Gallery

class MockPhotoManager: PhotoManagerProtocol {
    
    var initialLoadCalled = false
    var loadNextPageCalled = false
    var updateLikeStatusCalled = false
    var getImageResult: Result<Data, Error> = .success(Data())
    
    func initialLoad(_ type: Notification.Name) {
        initialLoadCalled = true
    }
    
    var fetchedPhotos: [Gallery.Photo] {
        return [MockPhoto.photo]
    }
    
    func loadNextPage() {
        loadNextPageCalled = true
    }
    
    func updateLikeStatus(photo: Gallery.Photo) {
        updateLikeStatusCalled = true
    }
    
    func getImage(for photo: Gallery.Photo, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(getImageResult)
    }
    
}
