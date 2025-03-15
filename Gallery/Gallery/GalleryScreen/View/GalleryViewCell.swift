//
//  GalleryPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

final class GalleryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "GalleryViewCell"
    
    private(set) var photoId: String = ""
    
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
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Methods
    
    func update(with photo: Photo) {
        photoId = photo.id
        heartImageView.isHidden = !photo.isLikedByUser
        imageView.image = nil
        imageView.backgroundColor = UIColor(hex: photo.color)
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    private func configure() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(imageView)
        imageView.addSubview(heartImageView)
    }
    
    private func setupConstraints() {
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
}
