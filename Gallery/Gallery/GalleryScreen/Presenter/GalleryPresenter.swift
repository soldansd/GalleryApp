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
    private let photoManager: PhotoPaginationManagerProtocol
    
    // MARK: - Init
    
    init(router: GalleryRouterProtocol, photoManager: PhotoPaginationManagerProtocol) {
        self.router = router
        self.photoManager = photoManager
        observeDataUpdates()
    }
    
    // MARK: - Methods
    
    private func observeDataUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePhotosUpdate(_:)),
            name: .photosDidUpdate,
            object: nil
        )
    }
    
    @objc private func handlePhotosUpdate(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.update()
        }
    }
    
    // MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .photosDidUpdate, object: nil)
    }
}

//MARK: - GalleryPresenterProtocol

extension GalleryPresenter: GalleryPresenterProtocol {
    
    var photos: [Photo] {
        photoManager.photos
    }
    
    func loadNextPage() {
        photoManager.loadNextPage()
    }
    
    func openDetailScreen(for photo: Photo) {
        router.openDetailScreen(for: photo)
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
}
