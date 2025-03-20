//
//  Extension+NotificationName.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

extension Notification.Name {
    static let fetchedPhotosDidUpdate = Notification.Name("fetchedPhotosDidUpdate")
    static let likedPhotosDidUpdate = Notification.Name("likedPhotosDidUpdate")
}
