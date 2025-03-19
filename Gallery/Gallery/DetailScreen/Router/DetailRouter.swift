//
//  DetailRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

final class DetailRouter {
    
    // MARK: - Properties
    
    private lazy var builder = DetailBuilder(router: self, photoManager: photoManager)
    
    private weak var navigationController: UINavigationController?
    private let photoManager: PhotoPaginationManagerProtocol
    
    // MARK: - Init
    
    init(navigationController: UINavigationController?, photoManager: PhotoPaginationManagerProtocol) {
        self.navigationController = navigationController
        self.photoManager = photoManager
    }
}

// MARK: - DetailRouterProtocol

extension DetailRouter: DetailRouterProtocol {
    
    func openDetailScreen(photo: Photo) {
        let view = builder.assembly(photo: photo)
        navigationController?.pushViewController(view, animated: true)
    }
    
    func closeDetailScreen() {
        navigationController?.popViewController(animated: true)
    }
}
