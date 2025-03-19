//
//  GalleryRouterProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

protocol GalleryRouterProtocol: AnyObject {
    func openDetailScreen(for photo: Photo, photos: [Photo])
}
