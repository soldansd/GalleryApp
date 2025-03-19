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
    private let photoManager: PhotoManagerProtocol
    private let observedNotification: Notification.Name
    
    // MARK: - Init
    
    init(
        router: GalleryRouterProtocol?,
        photoManager: PhotoManagerProtocol,
        observedNotification: Notification.Name
    ) {
        self.router = router
        self.photoManager = photoManager
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
