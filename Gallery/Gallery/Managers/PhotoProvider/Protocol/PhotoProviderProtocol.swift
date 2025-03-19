//
//  PhotoProviderProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

protocol PhotoProviderProtocol {
    func getListPhotos(page: Int, perPage: Int, completion: @escaping (Result<[Photo], Error>) -> Void)
    func getPhoto(id: String, completion: @escaping (Result<Photo, Error>) -> Void)
    func getImage(for photo: Photo, completion: @escaping (Result<Data, Error>) -> Void)
    func updateLikeStatus(photo: Photo)
    func getAllStoredFileNames() -> [String]
}
