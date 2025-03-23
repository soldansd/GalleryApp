//
//  DIContainer.swift
//  Gallery
//
//  Created by Даниил Соловьев on 23/03/2025.
//

import Foundation

final class DIContainer {
    
    private static var services = [String: Any]()

    static func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        services[key] = factory()
    }

    static func resolve<T>() -> T {
        let key = String(describing: T.self)
        guard let service = services[key] as? T else {
            fatalError("Service \(key) not registered")
        }
        return service
    }
}
