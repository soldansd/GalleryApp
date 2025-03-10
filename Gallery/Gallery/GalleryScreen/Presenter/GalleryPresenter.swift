//
//  GalleryPresenter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

protocol GalleryPresenterProtocol: AnyObject {
    var photos: [Photo] { get }
    func viewDidLoad()
    func loadNextPage()
    func getImage(for photo: Photo, completion: @escaping (Data?) -> Void)
}

final class GalleryPresenter: GalleryPresenterProtocol {
    
    weak var view: GalleryViewProtocol?
    private let router: GalleryRouterProtocol
    private(set) var photos: [Photo] = []
    private let photoManager: PhotoPaginationManagerProtocol
    
    init(router: GalleryRouterProtocol, photoManager: PhotoPaginationManagerProtocol) {
        self.router = router
        self.photoManager = photoManager
        observeDataUpdates()
    }
    
    func viewDidLoad() {
        photoManager.loadNextPage()
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
        if let updatedPhotos = notification.userInfo?["photos"] as? [Photo] {
            self.photos = updatedPhotos
            DispatchQueue.main.async { [weak self] in
                self?.view?.update()
            }
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
}
