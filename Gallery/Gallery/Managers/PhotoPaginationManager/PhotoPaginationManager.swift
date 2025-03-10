//
//  PhotoPaginationManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

final class PhotoPaginationManager {
    
    static let shared = PhotoPaginationManager(photoProvider: PhotoProvider.shared)
    
    private let photoProvider: PhotoProviderProtocol
    private var nextPage = 1
    private var perPage = 30
    private(set) var photos: [Photo] = []
    
    init(photoProvider: PhotoProviderProtocol) {
        self.photoProvider = photoProvider
    }
    
    func loadNextPage() {
        photoProvider.getListPhotos(page: nextPage, perPage: perPage) { [weak self] result in
            guard let self else {
                return
            }
            
            guard case .success(let photosPage) = result else {
                return
            }
            
            self.photos.append(contentsOf: photosPage)
            self.nextPage += 1
            notifyObservers()
        }
    }
    
    func updateLikeStatus(photo: Photo, isLiked: Bool) {
        if let index = photos.firstIndex(where: { $0.id == photo.id }) {
            photoProvider.updateLikeStatus(photo: photo, isLiked: isLiked)
            photos[index].isLikedByUser = isLiked
            notifyObservers()
        }
    }
    
    private func notifyObservers() {
        NotificationCenter.default.post(name: .photosDidUpdate, object: nil)
    }
}
