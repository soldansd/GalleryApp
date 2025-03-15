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
    
    // MARK: - Init
    
    init(router: GalleryRouterProtocol?) {
        self.router = router
    }
    
    // MARK: - Methods
    
    func assembly() -> UIViewController {
        guard let router else {
            return UIViewController()
        }
        
        let presenter = GalleryPresenter(router: router, photoManager: PhotoPaginationManager.shared)
        let view = GalleryViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
