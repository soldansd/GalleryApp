//
//  PhotoDTO.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

struct PhotoDTO: Decodable {
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
    let isLikedByUser: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case urls
        case user
        case description
        case altDescription = "alt_description"
        case width
        case height
        case color
        case blurHash = "blur_hash"
        case isLikedByUser = "liked_by_user"
        
        enum Urls: String, CodingKey {
            case small
        }
        
        enum User: String, CodingKey {
            case name
            case bio
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        altDescription = try container.decodeIfPresent(String.self, forKey: .altDescription) ?? ""
        width = try container.decode(Int.self, forKey: .width)
        height = try container.decode(Int.self, forKey: .height)
        color = try container.decode(String.self, forKey: .color)
        blurHash = try container.decode(String.self, forKey: .blurHash)
        isLikedByUser = try container.decode(Bool.self, forKey: .isLikedByUser)
        
        let urlsContainter = try container.nestedContainer(keyedBy: CodingKeys.Urls.self, forKey: .urls)
        imageURL = try urlsContainter.decode(String.self, forKey: .small)
        
        let userContainer = try container.nestedContainer(keyedBy: CodingKeys.User.self, forKey: .user)
        userName = try userContainer.decode(String.self, forKey: .name)
        userBio = try userContainer.decodeIfPresent(String.self, forKey: .bio) ?? ""
    }
}

extension PhotoDTO {
    
    func toModel() -> Photo {
        return Photo(
            id: self.id,
            imageURL: self.imageURL,
            userName: self.userName,
            userBio: self.userBio,
            description: self.description,
            altDescription: self.altDescription,
            width: self.width,
            height: self.height,
            color: self.color,
            blurHash: self.blurHash,
            isLikedByUser: self.isLikedByUser
        )
    }
}
