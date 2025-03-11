//
//  DetailPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

class DetailPhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailPhotoCollectionViewCell"
    
    var photoId: String = ""
    
    var likeButtonTapped: () -> Void = { }
    var backButtonTapped: () -> Void = { }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let scrollViewContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 300)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        
        configure()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(with photo: Photo) {
        userNameLabel.text = photo.userName
        descriptionLabel.text = photo.description
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let photoWidth = contentView.bounds.width
        let photoHeight = photoWidth * aspectRatio
        imageViewHeightConstraint.constant = photoHeight
        
        if photo.isLikedByUser {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        
        let image = UIImage(blurHash: photo.blurHash, size: CGSize(width: photoWidth, height: photoHeight))
        imageView.image = image
        
        layoutIfNeeded()
        scrollView.layoutIfNeeded()
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    private func configure() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(scrollView)
        contentView.addSubview(backButton)
        contentView.addSubview(likeButton)
        
        scrollView.addSubview(scrollViewContent)
        
        scrollViewContent.addSubview(imageView)
        scrollViewContent.addSubview(userNameLabel)
        scrollViewContent.addSubview(descriptionLabel)
        scrollViewContent.addSubview(userNameLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollViewContent.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor),
            imageViewHeightConstraint,
            
            userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            userNameLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 8),
            userNameLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -8),
            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollViewContent.bottomAnchor, constant: -8),
            
            likeButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 40),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func back() {
        backButtonTapped()
    }
    
    @objc private func like() {
        let currentImage = likeButton.image(for: .normal)
        
        if currentImage == UIImage(systemName: "heart") {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        likeButtonTapped()
    }
}
