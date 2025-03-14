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
    
    private var initialPhotoHeight = 0
    private var initialPhotoWidth = 0
    
    private let imagePadding: CGFloat = 4.0
    private let textPadding: CGFloat = 8.0
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
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
        label.font = .prostoOneRegular(size: 20)
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
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bioLabel, descriptionLabel, altDescriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = textPadding
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bioLabel: UILabel = createLabel(header: "bio")
    
    private lazy var descriptionLabel: UILabel = createLabel(header: "description")
    
    private lazy var altDescriptionLabel: UILabel = createLabel(header: "alt description")
    
    private func createLabel(header: String) -> UILabel {
        let label = PaddingLabel(header: header)
        label.font = .openSans(size: 16)
        label.numberOfLines = 0
        //label.layer.borderWidth = 1
        //label.layer.cornerRadius = 8
        label.layer.borderColor = UIColor.secondaryLabel.cgColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private lazy var imageViewHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 300)
    
    private lazy var imageViewWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: 300)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(like), for: .touchUpInside)
        
        configure()
    }
    
    required init?(coder: NSCoder) { nil }
    
    func configure(with photo: Photo) {
        initialPhotoWidth = photo.width
        initialPhotoHeight = photo.height
        userNameLabel.text = photo.userName
        bioLabel.text = photo.userBio
        bioLabel.isHidden = photo.userBio.isEmpty

        descriptionLabel.text = photo.description
        descriptionLabel.isHidden = photo.description.isEmpty
        
        altDescriptionLabel.text = photo.altDescription
        altDescriptionLabel.isHidden = photo.altDescription.isEmpty
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let photoWidth = contentView.bounds.width - 2 * imagePadding
        let photoHeight = photoWidth * aspectRatio
        imageViewWidthConstraint.constant = photoWidth
        imageViewHeightConstraint.constant = photoHeight
        
        if photo.isLikedByUser {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.tintColor = .label
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
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
//        scrollViewContent.addSubview(bioLabel)
//        scrollViewContent.addSubview(descriptionLabel)
//        scrollViewContent.addSubview(altDescriptionLabel)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
            likeButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            likeButton.widthAnchor.constraint(equalToConstant: 38),
            likeButton.heightAnchor.constraint(equalToConstant: 38),
            
            backButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
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
            infoStackView.bottomAnchor.constraint(equalTo: scrollViewContent.bottomAnchor, constant: -textPadding),
            
//            bioLabel.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
//            bioLabel.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
//            
//            descriptionLabel.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
//            descriptionLabel.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
//            
//            altDescriptionLabel.leadingAnchor.constraint(equalTo: infoStackView.leadingAnchor),
//            altDescriptionLabel.trailingAnchor.constraint(equalTo: infoStackView.trailingAnchor),
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            bioLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
            descriptionLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
            altDescriptionLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
        }
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.width > bounds.height {
            let aspectRatio = CGFloat(initialPhotoWidth) / CGFloat(initialPhotoHeight)
            var photoHeight = safeAreaLayoutGuide.layoutFrame.height - userNameLabel.bounds.height - imagePadding * 3
            var photoWidth = photoHeight * aspectRatio
            let safeAreaWidth = safeAreaLayoutGuide.layoutFrame.width
            if photoWidth > safeAreaWidth {
                photoWidth = safeAreaWidth - imagePadding * 2
            }
            photoHeight = photoWidth / aspectRatio
            imageViewWidthConstraint.constant = photoWidth
            imageViewHeightConstraint.constant = photoHeight
        } else {
            let aspectRatio = CGFloat(initialPhotoHeight) / CGFloat(initialPhotoWidth)
            let photoWidth = contentView.bounds.width - 2 * imagePadding
            let photoHeight = photoWidth * aspectRatio
            imageViewWidthConstraint.constant = photoWidth
            imageViewHeightConstraint.constant = photoHeight
        }
    }
}

class PaddingLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    private let headerText: String
    
    override var text: String? {
        didSet {
            updateAttributedText()
        }
    }
    
    override var font: UIFont! {
        didSet {
            updateAttributedText()
        }
    }

    init(header: String) {
        self.headerText = header
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) { return nil }

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: textInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        guard let text = self.text, !text.isEmpty else { return .zero }
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }

    func updateAttributedText() {
        guard let text = text, !text.isEmpty else {
            self.attributedText = nil
            return
        }
        
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: font.withSize(font.pointSize - 2),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.label
        ]
        
        let attributedString = NSMutableAttributedString(string: headerText + "\n", attributes: headerAttributes)
        attributedString.append(NSAttributedString(string: text, attributes: mainAttributes))
        
        self.attributedText = attributedString
    }
}
