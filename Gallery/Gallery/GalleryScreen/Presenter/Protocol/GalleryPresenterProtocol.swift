//
//  GalleryPresenterProtocol.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

import Foundation

protocol GalleryPresenterProtocol: AnyObject {
    var photos: [Photo] { get }
    func loadNextPage()
    func getImage(for photo: Photo, completion: @escaping (Data?) -> Void)
    func openDetailScreen(for photo: Photo)
}
