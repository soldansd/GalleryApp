//
//  PhotoPaginationManagerProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

protocol PhotoManagerProtocol {
    var fetchedPhotos: [Photo] { get }
    func loadNextPage()
    func updateLikeStatus(photo: Photo)
    func getImage(for photo: Photo, completion: @escaping (Result<Data, Error>) -> Void)
    func initialLoad(_ type: Notification.Name)
}
