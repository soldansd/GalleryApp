//
//  PhotoProvider.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

final class PhotoProvider: PhotoProviderProtocol {
    
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
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self else { return }
            
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
    }
    
    func updateLikeStatus(photo: Photo, isLiked: Bool) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let key = "\(photo.id).jpg"
            
            if isLiked {
                if let data = self.cacheManager.getData(forKey: key) {
                    try? self.storageManager.saveData(data, forKey: key)
                    self.cacheManager.removeData(forKey: key)
                }
            } else {
                if let data = self.storageManager.getData(forKey: key) {
                    self.cacheManager.saveData(data, forKey: key)
                    try? self.storageManager.removeData(forKey: key)
                }
            }
        }
    }
    
    func cancelTask(for urlString: String) {
        networkManager.cancelTask(for: urlString)
    }
}
