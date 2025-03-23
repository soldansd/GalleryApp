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
    
    private let photoManager: PhotoManagerProtocol = DIContainer.resolve()
    private let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        router: DetailRouterProtocol?,
        observedNotification: Notification.Name
    ) {
        self.router = router
        self.observedNotification = observedNotification
    }
    
    // MARK: - Methods
    
    func assembly(initialPhoto: Photo, photos: [Photo]) -> UIViewController {
        guard let router else {
            return UIViewController()
        }
        
        let presenter = DetailPresenter(
            router: router,
            photoManager: photoManager,
            initialPhoto: initialPhoto,
            photos: photos,
            observedNotification: observedNotification
        )
        let view = DetailViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
