//
//  DetailViewCellDelegate.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

protocol DetailViewCellDelegate: AnyObject {
    func likeButtonTapped(for photo: Photo)
    func backButtonTapped()
}
