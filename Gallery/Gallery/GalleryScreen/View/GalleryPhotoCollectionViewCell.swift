//
//  GalleryPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

class GalleryPhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GalleryPhotoCollectionViewCell"
    
    var photoId: String = ""
    var isLiked: Bool = false {
        didSet {
            heartImageView.isHidden = !isLiked
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let heartImageView: UIImageView = {
        let heart = UIImageView()
        heart.image = UIImage(systemName: "heart.fill")
        heart.tintColor = .red
        heart.translatesAutoresizingMaskIntoConstraints = false
        heart.isHidden = true
        return heart
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.addSubview(heartImageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            heartImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
            heartImageView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(with image: UIImage?) {
        imageView.image = image
    }
}
