//
//  MockNavigationController.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

import UIKit

final class MockNavigationController: UINavigationController {
    
    var pushedViewController: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController
    }
}
