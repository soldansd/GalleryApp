//
//  GalleryRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

final class GalleryRouter {
    
    // MARK: - Properties
    
    private lazy var builder = GalleryBuilder(
        router: self,
        photoManager: photoManager,
        observedNotification: observedNotification
    )
    private let photoManager: PhotoPaginationManagerProtocol
    private let observedNotification: Notification.Name
    
    private weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController?,
        photoManager: PhotoPaginationManagerProtocol,
        observedNotification: Notification.Name
    ) {
        self.navigationController = navigationController
        self.navigationController?.isNavigationBarHidden = true
        self.photoManager = photoManager
        self.observedNotification = observedNotification
    }
}

// MARK: - GalleryRouterProtocol

extension GalleryRouter: GalleryRouterProtocol {
    
    func openGalleryScreen() {
        let view = builder.assembly()
        navigationController?.pushViewController(view, animated: true)
    }
    
    func openDetailScreen(for photo: Photo, photos: [Photo]) {
        let router = DetailRouter(
            navigationController: navigationController,
            photoManager: photoManager,
            observedNotification: observedNotification
        )
        router.openDetailScreen(photo: photo, photos: photos)
    }
}
