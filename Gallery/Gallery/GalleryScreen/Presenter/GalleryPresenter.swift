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
}

final class GalleryPresenter: GalleryPresenterProtocol {
    
    weak var view: GalleryViewProtocol?
    private let router: GalleryRouterProtocol
    private(set) var photos: [Photo] = []
    private let networkManager = NetworkManager.shared
    
    init(router: GalleryRouterProtocol) {
        self.router = router
    }
    
    func viewDidLoad() {
        networkManager.getListPhotos(page: 1, perPage: 30) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                photos = success.map { $0.toModel() }
                
                DispatchQueue.main.async {
                    self.view?.update()
                }
            case .failure(let failure):
                break
            }
        }
    }
}
