//
//  DetailRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

final class DetailRouter {
    
    // MARK: - Properties
    
    private lazy var builder = DetailBuilder(
        router: self,
        photoManager: photoManager,
        observedNotification: observedNotification
    )
    
    private weak var navigationController: UINavigationController?
    private let photoManager: PhotoManagerProtocol
    private let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        navigationController: UINavigationController?,
        photoManager: PhotoManagerProtocol,
        observedNotification: Notification.Name
    ) {
        self.navigationController = navigationController
        self.photoManager = photoManager
        self.observedNotification = observedNotification
    }
}

// MARK: - DetailRouterProtocol

extension DetailRouter: DetailRouterProtocol {
    
    func openDetailScreen(photo: Photo, photos: [Photo]) {
        let view = builder.assembly(photo: photo, photos: photos)
        navigationController?.tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(view, animated: true)
    }
    
    func closeDetailScreen() {
        navigationController?.popViewController(animated: true)
        navigationController?.tabBarController?.tabBar.isHidden = false
    }
}
