//
//  MockPhoto.swift
//  GalleryTests
//
//  Created by Даниил Соловьев on 16/03/2025.
//

@testable import Gallery

struct MockPhoto {
    
    static let photo = Photo(
        id: "id",
        imageURL: "imageURL",
        userName: "userName",
        userBio: "userBio",
        description: "description",
        altDescription: "altDescription",
        width: 100,
        height: 200,
        color: "#FFFFFF",
        isLikedByUser: false
    )
}
