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
    
    private let photoManager: PhotoManagerProtocol = DIContainer.resolve()
    private let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        router: GalleryRouterProtocol?,
        observedNotification: Notification.Name
    ) {
        self.router = router
        self.observedNotification = observedNotification
    }
    
    // MARK: - Methods
    
    func assembly() -> UIViewController {
        guard let router else {
            return UIViewController()
        }
        
        let presenter = GalleryPresenter(
            router: router,
            photoManager: photoManager,
            observedNotification: observedNotification
        )
        let view = GalleryViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
}
