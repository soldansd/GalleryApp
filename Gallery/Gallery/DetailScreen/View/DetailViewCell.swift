//
//  DetailPhotoCollectionViewCell.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

final class DetailViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = "DetailViewCell"
    
    weak var delegate: DetailViewCellDelegate?
    private(set) var photo: Photo?
    
    private lazy var imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 300)
    private lazy var imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 300)
    
    private let imagePadding: CGFloat = 4.0
    private let textPadding: CGFloat = 8.0
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 19
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 19
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "chevron.left")
        config.baseForegroundColor = .label
        
        button.configuration = config
        
        return button
    }()
    
    private let likeButton = HeartButton()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .prostoOneRegular(size: 20)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioLabel: UILabel = InfoLabel(header: "bio")
    
    private let descriptionLabel: UILabel = InfoLabel(header: "description")
    
    private let altDescriptionLabel: UILabel = InfoLabel(header: "alt description")
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bioLabel, descriptionLabel, altDescriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = textPadding
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        configure()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.width > bounds.height {
            updateImageViewConstraintsToLandscapeMode()
        } else {
            updateImageViewConstraintsToPortraitMode()
        }
    }
    
    // MARK: - Methods
    
    func update(with photo: Photo) {
        self.photo = photo
        
        userNameLabel.text = photo.userName
        
        bioLabel.text = photo.userBio
        bioLabel.isHidden = photo.userBio.isEmpty

        descriptionLabel.text = photo.description
        descriptionLabel.isHidden = photo.description.isEmpty
        
        altDescriptionLabel.text = photo.altDescription
        altDescriptionLabel.isHidden = photo.altDescription.isEmpty
        
        likeButton.update(isLiked: photo.isLikedByUser)
        
        imageView.image = nil
        imageView.backgroundColor = UIColor(hex: photo.color)
        
        backgroundColor = UIColor(hex: photo.color)
        
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
        contentView.addSubview(blurEffectView)
        contentView.addSubview(backButton)
        contentView.addSubview(likeButton)
        
        blurEffectView.contentView.addSubview(scrollView)
        
        scrollView.addSubview(scrollViewContent)
        
        scrollViewContent.addSubview(imageView)
        scrollViewContent.addSubview(userNameLabel)
        scrollViewContent.addSubview(infoStackView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            likeButton.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 38),
            likeButton.heightAnchor.constraint(equalToConstant: 38),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            backButton.widthAnchor.constraint(equalToConstant: 38),
            backButton.heightAnchor.constraint(equalToConstant: 38),
            
            blurEffectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.trailingAnchor),
            
            scrollViewContent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollViewContent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollViewContent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollViewContent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollViewContent.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollViewContent.topAnchor, constant: imagePadding),
            imageView.centerXAnchor.constraint(equalTo: scrollViewContent.centerXAnchor),
            imageView.bottomAnchor.constraint(equalTo: userNameLabel.topAnchor, constant: -textPadding),
            imageViewWidthConstraint,
            imageViewHeightConstraint,
            
            userNameLabel.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: textPadding),
            userNameLabel.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -textPadding),
            userNameLabel.bottomAnchor.constraint(equalTo: infoStackView.topAnchor, constant: -textPadding),
            
            infoStackView.leadingAnchor.constraint(equalTo: scrollViewContent.leadingAnchor, constant: textPadding),
            infoStackView.trailingAnchor.constraint(equalTo: scrollViewContent.trailingAnchor, constant: -textPadding),
            infoStackView.bottomAnchor.constraint(equalTo: scrollViewContent.bottomAnchor, constant: -textPadding)
        ])
    }
    
    private func updateImageViewConstraintsToLandscapeMode() {
        guard let photo else { return }
        
        let aspectRatio = CGFloat(photo.width) / CGFloat(photo.height)
        var photoHeight = safeAreaLayoutGuide.layoutFrame.height - userNameLabel.bounds.height - imagePadding * 3
        var photoWidth = photoHeight * aspectRatio
        let safeAreaWidth = safeAreaLayoutGuide.layoutFrame.width
        if photoWidth > safeAreaWidth {
            photoWidth = safeAreaWidth - imagePadding * 2
        }
        photoHeight = photoWidth / aspectRatio
        
        updateImageViewConstraints(width: photoWidth, height: photoHeight)
    }
    
    private func updateImageViewConstraintsToPortraitMode() {
        guard let photo else { return }
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let photoWidth = contentView.bounds.width - 2 * imagePadding
        let photoHeight = photoWidth * aspectRatio
        
        updateImageViewConstraints(width: photoWidth, height: photoHeight)
    }
    
    private func updateImageViewConstraints(width: CGFloat, height: CGFloat) {
        imageViewWidthConstraint.constant = width
        imageViewHeightConstraint.constant = height
    }
    
    @objc private func backButtonTapped() {
        delegate?.backButtonTapped()
    }
    
    @objc private func likeButtonTapped() {
        photo?.isLikedByUser.toggle()
        
        guard let photo else { return }
        
        delegate?.likeButtonTapped(for: photo)
    }
}
