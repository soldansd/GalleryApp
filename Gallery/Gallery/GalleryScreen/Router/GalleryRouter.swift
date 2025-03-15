//
//  GalleryRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

final class GalleryRouter {
    
    // MARK: - Properties
    
    private lazy var builder = GalleryBuilder(router: self)
    
    private weak var navigationController: UINavigationController?
    
    // MARK: - Init
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - GalleryRouterProtocol

extension GalleryRouter: GalleryRouterProtocol {
    
    func openGalleryScreen() {
        let view = builder.assembly()
        navigationController?.pushViewController(view, animated: true)
    }
    
    func openDetailScreen(for photo: Photo) {
        let router = DetailRouter(navigationController: navigationController)
        router.openDetailScreen(photo: photo)
    }
}
