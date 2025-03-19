//
//  DetailBuilder.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

struct DetailBuilder {
    
    // MARK: - Properties
    
    private weak var router: DetailRouterProtocol?
    private let photoManager: PhotoPaginationManagerProtocol
    
    // MARK: - Init
    
    init(router: DetailRouterProtocol?, photoManager: PhotoPaginationManagerProtocol) {
        self.router = router
        self.photoManager = photoManager
    }
    
    // MARK: - Methods
    
    func assembly(photo: Photo) -> UIViewController {
        guard let router else {
            return UIViewController()
        }
        
        let presenter = DetailPresenter(router: router, photoManager: photoManager, photo: photo)
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
