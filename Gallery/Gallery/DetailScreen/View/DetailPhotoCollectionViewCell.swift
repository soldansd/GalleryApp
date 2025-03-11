//
//  DetailPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

class DetailPhotoCollectionViewCell: UICollectionViewCell {
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "picture")
        return imageView
    }()
    
}
