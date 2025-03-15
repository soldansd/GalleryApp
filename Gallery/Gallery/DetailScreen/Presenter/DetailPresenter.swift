//
//  DetailPresenter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

final class DetailPresenter {
    
    //MARK: - Properties
    
    weak var view: DetailViewProtocol?
    private let router: DetailRouterProtocol
    private let photoManager: PhotoPaginationManagerProtocol
    let initialPhoto: Photo
    
    //MARK: - Init
    
    init(router: DetailRouterProtocol, photoManager: PhotoPaginationManagerProtocol, photo: Photo) {
        self.router = router
        self.photoManager = photoManager
        self.initialPhoto = photo
        observeDataUpdates()
    }
    
    //MARK: - Methods
    
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
    
    //MARK: - Deinit
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .photosDidUpdate, object: nil)
    }
}

//MARK: - DetailPresenterProtocol

extension DetailPresenter: DetailPresenterProtocol {
    
    var photos: [Photo] {
        photoManager.photos
    }
    
    func loadNextPage() {
        photoManager.loadNextPage()
    }
    
    func updateLikeStatus(photo: Photo, isLiked: Bool) {
        photoManager.updateLikeStatus(photo: photo, isLiked: isLiked)
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
}
