//
//  DetailPresenter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    
    var photos: [Photo] { get }
    var currentPhoto: Photo { get }
    func loadNextPage()
    func getImage(for photo: Photo, completion: @escaping (Data?) -> Void)
}

class DetailPresenter: DetailPresenterProtocol {
    
    weak var view: DetailViewProtocol?
    private let router: DetailRouterProtocol
    private let photoManager: PhotoPaginationManagerProtocol
    private(set) var currentPhoto: Photo
    
    var photos: [Photo] {
        photoManager.photos
    }
    
    init(router: DetailRouterProtocol, photoManager: PhotoPaginationManagerProtocol, photo: Photo) {
        self.router = router
        self.photoManager = photoManager
        self.currentPhoto = photo
        observeDataUpdates()
    }
    
    func loadNextPage() {
        photoManager.loadNextPage()
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
    
    @objc private func handlePhotosUpdate(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.update()
        }
    }
    
    private func observeDataUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePhotosUpdate(_:)),
            name: .photosDidUpdate,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .photosDidUpdate, object: nil)
    }
}
