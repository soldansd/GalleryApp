//
//  GalleryPresenter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

final class GalleryPresenter {
    
    // MARK: - Properties
    
    weak var view: GalleryViewProtocol?
    private let router: GalleryRouterProtocol
    private let photoManager: PhotoManagerProtocol
    private(set) var photos: [Photo] = []
    private let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        router: GalleryRouterProtocol,
        photoManager: PhotoManagerProtocol,
        observedNotification: Notification.Name
    ) {
        self.router = router
        self.photoManager = photoManager
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
            if self?.observedNotification == .likedPhotosDidUpdate {
                self?.view?.reload()
            }
            self?.view?.update()
        }
    }
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: observedNotification, object: nil)
    }
}

// MARK: - GalleryPresenterProtocol

extension GalleryPresenter: GalleryPresenterProtocol {
    
    func initialLoad() {
        photoManager.initialLoad(observedNotification)
    }
    
    func loadNextPage() {
        photoManager.loadNextPage()
    }
    
    func openDetailScreen(for photo: Photo, photos: [Photo]) {
        router.openDetailScreen(for: photo, photos: photos)
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
        if index == photos.count - 1, observedNotification == .fetchedPhotosDidUpdate {
            loadNextPage()
        }
    }
}
