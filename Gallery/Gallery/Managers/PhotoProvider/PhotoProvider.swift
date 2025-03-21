//
//  PhotoProvider.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import Foundation

final class PhotoProvider: PhotoProviderProtocol {
    
    // MARK: - Properties
    
    private let storageManager: StorageManagerProtocol
    private let cacheManager: CacheManagerProtocol
    private let networkManager: NetworkManagerProtocol
    
    // MARK: - Init
    
    init(
        storageManager: StorageManagerProtocol,
        cacheManager: CacheManagerProtocol,
        networkManager: NetworkManagerProtocol
    ) {
        self.storageManager = storageManager
        self.cacheManager = cacheManager
        self.networkManager = networkManager
    }
    
    // MARK: - Methods
    
    func getListPhotos(page: Int, perPage: Int, completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        networkManager.getListPhotos(page: page, perPage: perPage) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let photosDTO):
                let photos = photosDTO.map { self.processPhoto($0) }
                completion(.success(photos))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPhoto(id: String, completion: @escaping (Result<Photo, Error>) -> Void) {
        
        networkManager.getPhoto(id: id) { [weak self] result in
            guard let self else {
                return
            }
            
            switch result {
            case .success(let photoDTO):
                let photo = processPhoto(photoDTO)
                completion(.success(photo))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getImage(for photo: Photo, completion: @escaping (Result<Data, Error>) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            
            if photo.isLikedByUser, let data = storageManager.getData(forKey: "\(photo.id)") {
                completion(.success(data))
                return
            }
            
            if let data = cacheManager.getData(forKey: "\(photo.id)") {
                completion(.success(data))
                return
            }
            
            networkManager.getData(from: photo.imageURL) { result in
                
                switch result {
                case .success(let data):
                    
                    if photo.isLikedByUser {
                       try? self.storageManager.saveData(data, forKey: "\(photo.id)")
                    } else {
                        self.cacheManager.saveData(data, forKey: "\(photo.id)")
                    }
                    
                    completion(.success(data))
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateLikeStatus(photo: Photo) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            let key = "\(photo.id)"
            
            if photo.isLikedByUser {
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
    
    func getAllStoredFileNames() -> [String] {
        return storageManager.getAllStoredFileNames()
    }
    
    private func processPhoto(_ photoDTO: PhotoDTO) -> Photo {
        var photo = photoDTO.toModel()
        if storageManager.getData(forKey: "\(photo.id)") != nil {
            photo.isLikedByUser = true
        }
        return photo
    }
}
