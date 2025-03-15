//
//  DetailPresenterProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    
    var photos: [Photo] { get }
    var initialPhoto: Photo { get }
    func loadNextPage()
    func getImage(for photo: Photo, completion: @escaping (Data?) -> Void)
    func updateLikeStatus(photo: Photo, isLiked: Bool)
    func closeDetailScreen()
}
