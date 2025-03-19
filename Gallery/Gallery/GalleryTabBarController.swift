//
//  GalleryTabBarController.swift
//  Gallery
//
//  Created by Даниил Соловьев on 20/03/2025.
//

import UIKit

final class GalleryTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let photoManager: PhotoManagerProtocol
    
    // MARK: - Init
    
    init(photoManager: PhotoManagerProtocol) {
        self.photoManager = photoManager
        super.init(nibName: nil, bundle: nil)
        setupTabs()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Methods
    
    private func setupTabs() {
        
        let galleryNavigationController = UINavigationController()
        galleryNavigationController.tabBarItem = UITabBarItem(
            title: "Gallery",
            image: UIImage(systemName: "photo.on.rectangle.angled"),
            selectedImage: UIImage(systemName: "photo.on.rectangle.angled.fill")
        )
        
        let galleryRouter = GalleryRouter(
            navigationController: galleryNavigationController,
            photoManager: photoManager,
            observedNotification: .photosDidUpdate
        )
        
        let favouriteNavigationController = UINavigationController()
        favouriteNavigationController.tabBarItem = UITabBarItem(
            title: "Favourite",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )
        
        let favouriteRouter = GalleryRouter(
            navigationController: favouriteNavigationController,
            photoManager: photoManager,
            observedNotification: .likedPhotosDidUpdate
        )
        
        galleryRouter.openGalleryScreen()
        favouriteRouter.openGalleryScreen()
        
        viewControllers = [galleryNavigationController, favouriteNavigationController]
        tabBar.tintColor = .appTint
    }
    
}
