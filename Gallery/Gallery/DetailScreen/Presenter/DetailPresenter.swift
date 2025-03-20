//
//  DetailPresenter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

final class DetailPresenter {
    
    // MARK: - Properties
    
    weak var view: DetailViewProtocol?
    private let router: DetailRouterProtocol
    private let photoManager: PhotoManagerProtocol
    let initialPhoto: Photo
    private(set) var photos: [Photo]
    let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        router: DetailRouterProtocol,
        photoManager: PhotoManagerProtocol,
        initialPhoto: Photo,
        photos: [Photo],
        observedNotification: Notification.Name
    ) {
        self.router = router
        self.photoManager = photoManager
        self.initialPhoto = initialPhoto
        self.photos = photos
        self.observedNotification = observedNotification
        observeDataUpdates()
    }
    
    // MARK: - Methods
    
    private func observeDataUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePhotosUpdate(_:)),
            name: observedNotification,
            object: nil
        )
    }
    
    @objc private func handlePhotosUpdate(_ notification: Notification) {
        guard let fetchedPhotos = notification.object as? [Photo] else { return }
        self.photos = fetchedPhotos
        DispatchQueue.main.async { [weak self] in
            
            guard let self else { return }
            
            guard !self.photos.isEmpty else {
                closeDetailScreen()
                return
            }
            
            self.view?.update()
        }
    }
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .photosDidUpdate, object: nil)
    }
}

// MARK: - DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
    
    func loadNextPage() {
        photoManager.loadNextPage()
    }
    
    func updateLikeStatus(photo: Photo) {
        photoManager.updateLikeStatus(photo: photo)
    }
    
    func closeDetailScreen() {
        router.closeDetailScreen()
    }
    
    func getImage(for photo: Photo, completion: @escaping (Data?) -> Void) {
        photoManager.getImage(for: photo) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    completion(data)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
    
    func updateIfNeeded(index: Int) {
        if index == photos.count - 1, observedNotification == .photosDidUpdate {
            loadNextPage()
        }
    }
}
