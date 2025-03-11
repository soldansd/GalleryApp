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
    func openDetailScreen(for photo: Photo)
}

final class GalleryPresenter: GalleryPresenterProtocol {
    
    weak var view: GalleryViewProtocol?
    private let router: GalleryRouterProtocol
    private let photoManager: PhotoPaginationManagerProtocol
    
    var photos: [Photo] {
        photoManager.photos
    }
    
    init(router: GalleryRouterProtocol, photoManager: PhotoPaginationManagerProtocol) {
        self.router = router
        self.photoManager = photoManager
        observeDataUpdates()
    }
    
    func viewDidLoad() {
        loadNextPage()
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
