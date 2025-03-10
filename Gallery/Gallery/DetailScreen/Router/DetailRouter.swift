//
//  DetailRouter.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

protocol DetailRouterProtocol: AnyObject {
    
}

class DetailRouter: DetailRouterProtocol {
    
    private lazy var builder = DetailBuilder(router: self)
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func openDetailScreen(photo: Photo) {
        let view = builder.assembly(photo: photo)
        navigationController?.pushViewController(view, animated: true)
    }
}
