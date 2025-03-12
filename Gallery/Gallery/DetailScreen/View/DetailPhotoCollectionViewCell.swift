//
//  DetailPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//
// swiftlint:disable all

import UIKit

class DetailPhotoCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "DetailPhotoCollectionViewCell"
    
    var photoId: String = ""
    
    var likeButtonTapped: () -> Void = { }
    var backButtonTapped: () -> Void = { }
    
    private let imagePadding: CGFloat = 4.0
    private let textPadding: CGFloat = 8.0
    
    private var gradientLayer: CAGradientLayer?
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.black.cgColor,  // Default Start Color
            UIColor.clear.cgColor   // Default End Color
        ]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.frame = contentView.bounds
        gradientLayer.name = "gradientLayer"

        contentView.layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer  // Store reference
    }
    
    func updateGradientColors(startColor: UIColor, endColor: UIColor) {
        guard let gradientLayer = gradientLayer else { return }
        
        let animation = CABasicAnimation(keyPath: "colors")
        animation.fromValue = gradientLayer.colors
        animation.toValue = [startColor.cgColor, endColor.cgColor]
        animation.duration = 0.5 // Smooth transition
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        gradientLayer.add(animation, forKey: "colorChange")
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor] // Ensure final state
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 19
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
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 19
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        let image = UIImage(systemName: "chevron.left")
        config.image = UIImage(systemName: "chevron.left")
        config.imagePadding = 0
        config.baseForegroundColor = .label
        
        button.configuration = config
        
        return button
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .prostoOneRegular(size: 18)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.tintColor = .label
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
        let photoWidth = contentView.bounds.width - 2 * imagePadding
        let photoHeight = photoWidth * aspectRatio
        imageViewHeightConstraint.constant = photoHeight
        
        if photo.isLikedByUser {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = .label
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        let image = UIImage(blurHash: photo.blurHash, size: CGSize(width: photoWidth, height: photoHeight))
        imageView.image = image
        
        updateGradientColors(startColor: UIColor(hex: photo.color) ?? .clear, endColor: .clear)
        
        layoutIfNeeded()
        scrollView.layoutIfNeeded()
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
    
    private func configure() {
        addGradientLayer()
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(scrollView)
        
        //contentView.addSubview(scrollView)
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
            blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: blurEffectView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: blurEffectView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollViewContent.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: imagePadding),
            imageView.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -imagePadding),
            imageViewHeightConstraint,
            
            userNameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: textPadding),
            userNameLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: textPadding),
            userNameLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -textPadding),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: textPadding),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -textPadding),
            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: textPadding),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollViewContent.bottomAnchor, constant: -textPadding),
            
            likeButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 38),
            likeButton.heightAnchor.constraint(equalToConstant: 38),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            backButton.widthAnchor.constraint(equalToConstant: 38),
            backButton.heightAnchor.constraint(equalToConstant: 38)
        ])
    }
    
    @objc private func back() {
        backButtonTapped()
    }
    
    @objc private func like() {
        let currentImage = likeButton.image(for: .normal)
        
        if currentImage == UIImage(systemName: "heart") {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = .label
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        likeButtonTapped()
    }
}
