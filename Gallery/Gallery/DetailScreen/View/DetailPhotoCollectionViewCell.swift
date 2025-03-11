//
//  DetailPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

class DetailPhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailPhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .cyan
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
        button.backgroundColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Daniil Solovyev"
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .orange
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.backgroundColor = .purple
        label.text = "agfdfsdgdfhsgbnfjdhgbhjfdbgshjkbgfjhdsbgjfhkbsjhfkdgbfjdhsbgjhksdgjhbdfjkgbhk"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 300)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(with photo: Photo) {
        userNameLabel.text = photo.userName
        descriptionLabel.text = photo.description
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let photoHeight = contentView.bounds.width * aspectRatio
        imageViewHeightConstraint.constant = photoHeight
        
        layoutIfNeeded()
        scrollView.layoutIfNeeded()
    }
    
    private func configure() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(scrollView)
        contentView.addSubview(backButton)
        
        scrollView.addSubview(scrollViewContent)
        
        scrollViewContent.addSubview(imageView)
        scrollViewContent.addSubview(userNameLabel)
        scrollViewContent.addSubview(likeButton)
        scrollViewContent.addSubview(descriptionLabel)
        scrollViewContent.addSubview(userStackView)
        
        userStackView.addSubview(userNameLabel)
        userStackView.addSubview(likeButton)
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
            
            userStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            userStackView.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 8),
            userStackView.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -8),
            
            userNameLabel.topAnchor.constraint(equalTo: userStackView.topAnchor),
            userNameLabel.bottomAnchor.constraint(equalTo: userStackView.bottomAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userStackView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -8),
            
            likeButton.topAnchor.constraint(equalTo: userStackView.topAnchor),
            likeButton.bottomAnchor.constraint(equalTo: userStackView.bottomAnchor),
            likeButton.trailingAnchor.constraint(equalTo: userStackView.trailingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -8),
            descriptionLabel.topAnchor.constraint(equalTo: userStackView.bottomAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollViewContent.bottomAnchor, constant: -8),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
}
