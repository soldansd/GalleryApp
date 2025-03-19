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
    private let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        router: DetailRouterProtocol?,
        photoManager: PhotoPaginationManagerProtocol,
        observedNotification: Notification.Name
    ) {
        self.router = router
        self.photoManager = photoManager
        self.observedNotification = observedNotification
    }
    
    // MARK: - Methods
    
    func assembly(photo: Photo, photos: [Photo]) -> UIViewController {
        guard let router else {
            return UIViewController()
        }
        
        let presenter = DetailPresenter(
            router: router,
            photoManager: photoManager,
            initialPhoto: photo,
            photos: photos,
            observedNotification: observedNotification
        )
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
