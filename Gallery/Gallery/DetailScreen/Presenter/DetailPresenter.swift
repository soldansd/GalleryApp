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
}
