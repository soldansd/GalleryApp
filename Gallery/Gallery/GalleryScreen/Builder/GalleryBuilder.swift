//
//  GalleryBuilder.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

struct GalleryBuilder {
    
    // MARK: - Properties
    
    private weak var router: GalleryRouterProtocol?
    private let photoManager: PhotoPaginationManagerProtocol
    
    // MARK: - Init
    
    init(router: GalleryRouterProtocol?, photoManager: PhotoPaginationManagerProtocol) {
        self.router = router
        self.photoManager = photoManager
    }
    
    // MARK: - Methods
    
    func assembly() -> UIViewController {
        guard let router else {
            return UIViewController()
        }
        
        let presenter = GalleryPresenter(router: router, photoManager: photoManager)
        let view = GalleryViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
