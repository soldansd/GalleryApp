//
//  Photo.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

struct Photo {
    let id: String
    let imageURL: String
    let userName: String
    let userBio: String
    let description: String
    let altDescription: String
    let width: Int
    let height: Int
    let color: String
    let blurHash: String
    var isLikedByUser: Bool
}
