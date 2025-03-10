//
//  PhotoPaginationManagerProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

protocol PhotoPaginationManagerProtocol {
    
    var photos: [Photo] { get }
    
    func loadNextPage()
    func updateLikeStatus(photo: Photo, isLiked: Bool)
    func getImage(for photo: Photo, completion: @escaping (Result<Data, Error>) -> Void)
}
