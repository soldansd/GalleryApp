//
//  PhotoPaginationManager.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

final class PhotoManager: PhotoManagerProtocol {
    
    // MARK: - Properties
    
    private let photoProvider: PhotoProviderProtocol
    private var nextPage = 1
    private var perPage = 30
    
    private(set) var fetchedPhotos: [Photo] = []
    private var isLoadingNextPage = false
    
    private(set) var likedPhotos: [Photo] = []
    private var isLoadingLikedPhotos = false
    
    // MARK: - Init
    
    init(photoProvider: PhotoProviderProtocol) {
        self.photoProvider = photoProvider
    }
    
    func initialLoad(_ type: Notification.Name) {
        switch type {
        case .fetchedPhotosDidUpdate:
            loadNextPage()
        case .likedPhotosDidUpdate:
            loadLikedPhotos()
        default:
            break
        }
    }
    
    // MARK: - Methods
    
    func loadNextPage() {
        guard !isLoadingNextPage else {
            return
        }
        
        isLoadingNextPage = true
        
        photoProvider.getListPhotos(page: nextPage, perPage: perPage) { [weak self] result in
            guard let self else {
                return
            }
            
            guard case .success(let photosPage) = result else {
                return
            }
            
            self.fetchedPhotos.append(contentsOf: photosPage)
            self.nextPage += 1
            self.isLoadingNextPage = false
            notifyFetchedPhotosObservers()
        }
    }
    
    func getImage(for photo: Photo, completion: @escaping (Result<Data, Error>) -> Void) {
        photoProvider.getImage(for: photo, completion: completion)
    }
    
    func updateLikeStatus(photo: Photo) {
        
        if photo.isLikedByUser {
            likedPhotos.append(photo)
        } else if let index = likedPhotos.firstIndex(where: { $0.id == photo.id }) {
            likedPhotos.remove(at: index)
        }
        
        if let index = fetchedPhotos.firstIndex(where: { $0.id == photo.id }) {
            fetchedPhotos[index].isLikedByUser = photo.isLikedByUser
        }
        
        photoProvider.updateLikeStatus(photo: photo)
        notifyAllObservers()
    }
    
    private func loadLikedPhotos() {
        guard !isLoadingLikedPhotos else { return }
        
        isLoadingLikedPhotos = true
        
        let likedPhotoIDs = photoProvider.getAllStoredFileNames()
        likedPhotos.removeAll()
        for id in likedPhotoIDs {
            photoProvider.getPhoto(id: id) { [weak self] result in
                guard let self else {
                    return
                }
                
                guard case .success(let photo) = result else {
                    return
                }
                
                likedPhotos.append(photo)
                
                if likedPhotos.count == likedPhotoIDs.count {
                    isLoadingLikedPhotos = false
                    notifyLikedPhotosObservers()
                }
            }
        }
    }
    
    private func notifyAllObservers() {
        notifyLikedPhotosObservers()
        notifyFetchedPhotosObservers()
    }
    
    private func notifyLikedPhotosObservers() {
        NotificationCenter.default.post(name: .likedPhotosDidUpdate, object: likedPhotos)
    }
    
    private func notifyFetchedPhotosObservers() {
        NotificationCenter.default.post(name: .fetchedPhotosDidUpdate, object: fetchedPhotos)
    }
}
