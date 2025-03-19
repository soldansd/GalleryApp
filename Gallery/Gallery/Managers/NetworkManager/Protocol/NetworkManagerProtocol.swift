//
//  NetworkManagerProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

protocol NetworkManagerProtocol {
    
    func getListPhotos(
        page: Int,
        perPage: Int,
        completion: @escaping (Result<[PhotoDTO], Error>) -> Void
    )
    
    func getPhoto(
        id: String,
        completion: @escaping (Result<PhotoDTO, Error>) -> Void
    )
    
    func getData(
        from urlString: String,
        completion: @escaping (Result<Data, Error>) -> Void
    )

}
