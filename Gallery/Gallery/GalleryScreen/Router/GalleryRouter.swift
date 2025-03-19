//
//  GalleryRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

final class GalleryRouter {
    
    // MARK: - Properties
    
    private lazy var builder = GalleryBuilder(router: self, photoManager: photoManager)
    private let photoManager: PhotoPaginationManagerProtocol
    
    private weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController?, photoManager: PhotoPaginationManagerProtocol) {
        self.navigationController = navigationController
        self.navigationController?.isNavigationBarHidden = true
        self.photoManager = photoManager
    }
}

// MARK: - GalleryRouterProtocol

extension GalleryRouter: GalleryRouterProtocol {
    
    func openGalleryScreen() {
        let view = builder.assembly()
        navigationController?.pushViewController(view, animated: true)
    }
    
    func openDetailScreen(for photo: Photo) {
        let router = DetailRouter(navigationController: navigationController, photoManager: photoManager)
        router.openDetailScreen(photo: photo)
    }
}
