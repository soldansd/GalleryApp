//
//  PhotoProvider.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

class PhotoProvider: PhotoProviderProtocol {
    
    static let shared = PhotoProvider(
        storageManager: StorageManager.shared,
        cacheManager: CacheManager.shared,
        networkManager: NetworkManager.shared
    )
    
    private let storageManager: StorageManagerProtocol
    private let cacheManager: CacheManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    init(
        storageManager: StorageManagerProtocol,
        cacheManager: CacheManagerProtocol,
        networkManager: NetworkManagerProtocol
    ) {
        self.storageManager = storageManager
        self.cacheManager = cacheManager
        self.networkManager = networkManager
    }
    
    func getListPhotos(page: Int, perPage: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        networkManager.getListPhotos(page: page, perPage: perPage) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let photosDTO):
                
                let photos = photosDTO.map { dto -> Photo in
                    var photo = dto.toModel()
                    if self.storageManager.getData(forKey: "\(photo.id).jpg") != nil {
                        photo.isLikedByUser = true
                    }
                    return photo
                }
            
                completion(.success(photos))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getImage(for photo: Photo, completion: @escaping (Result<Data, Error>) -> Void) {
        
        if photo.isLikedByUser, let data = storageManager.getData(forKey: "\(photo.id).jpg") {
            completion(.success(data))
            return
        }
        
        if let data = cacheManager.getData(forKey: "\(photo.id).jpg") {
            completion(.success(data))
            return
        }
        
        networkManager.getImage(from: photo.imageURL) { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let data):
                
                if photo.isLikedByUser {
                   try? self.storageManager.saveData(data, forKey: "\(photo.id).jpg")
                } else {
                    self.cacheManager.saveData(data, forKey: "\(photo.id).jpg")
                }
                
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateLikeStatus(photo: Photo, isLiked: Bool) {
        let key = "\(photo.id).jpg"
        
        if isLiked {
            if let data = cacheManager.getData(forKey: key) {
                try? storageManager.saveData(data, forKey: key)
                cacheManager.removeData(forKey: key)
            }
        } else {
            if let data = storageManager.getData(forKey: key) {
                cacheManager.saveData(data, forKey: key)
                try? storageManager.removeData(forKey: key)
            }
        }
    }
}
