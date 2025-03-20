//
//  DetailRouterProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

protocol DetailRouterProtocol: AnyObject {
    func openDetailScreen(initialPhoto: Photo, photos: [Photo])
    func closeDetailScreen()
}
