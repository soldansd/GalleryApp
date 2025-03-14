//
//  GalleryPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

protocol GalleryPhotoCollectionViewCellDelegate: AnyObject {
    func prepareForReuse(urlStirng: String)
}

class GalleryPhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GalleryPhotoCollectionViewCell"
    
    private(set) var photoId: String = ""
    private(set) var urlString: String = ""
    weak var delegate: GalleryPhotoCollectionViewCellDelegate?
    
    private(set) var isLiked: Bool = false {
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
            heartImageView.widthAnchor.constraint(equalToConstant: 20),
            heartImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(with photo: Photo) {
        photoId = photo.id
        isLiked = photo.isLikedByUser
        urlString = photo.imageURL
        imageView.image = nil
        imageView.backgroundColor = UIColor(hex: photo.color)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate?.prepareForReuse(urlStirng: urlString)
    }
}
