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
        observedNotification: observedNotification
    )
    
    private weak var navigationController: UINavigationController?
    
    private let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController?,
        observedNotification: Notification.Name
    ) {
        self.navigationController = navigationController
        self.navigationController?.isNavigationBarHidden = true
        self.observedNotification = observedNotification
    }
}

// MARK: - GalleryRouterProtocol

extension GalleryRouter: GalleryRouterProtocol {
    
    func openGalleryScreen() {
        let view = builder.assembly()
        navigationController?.pushViewController(view, animated: true)
    }
    
    func openDetailScreen(for initialPhoto: Photo, photos: [Photo]) {
        let router = DetailRouter(
            navigationController: navigationController,
            observedNotification: observedNotification
        )
        router.openDetailScreen(initialPhoto: initialPhoto, photos: photos)
    }
}
