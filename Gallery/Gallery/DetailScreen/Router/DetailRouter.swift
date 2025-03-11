//
//  DetailRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
    func openDetailScreen(photo: Photo)
    func closeDetailScreen()
}

class DetailRouter: DetailRouterProtocol {
    
    private lazy var builder = DetailBuilder(router: self)
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func openDetailScreen(photo: Photo) {
        let view = builder.assembly(photo: photo)
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(view, animated: true)
    }
    
    func closeDetailScreen() {
        navigationController?.popViewController(animated: true)
    }
}
