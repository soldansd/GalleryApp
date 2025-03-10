//
//  DetailBuilder.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

struct DetailBuilder {
    
    private weak var router: DetailRouterProtocol?
    
    init(router: DetailRouterProtocol?) {
        self.router = router
    }
    
    func assembly(photo: Photo) -> UIViewController {
        guard let router else {
            return UIViewController()
        }
        
        let presenter = DetailPresenter(router: router, photoManager: PhotoPaginationManager.shared, photo: photo)
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
