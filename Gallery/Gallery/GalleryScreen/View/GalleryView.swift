//
//  GalleryView.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

import UIKit

final class GalleryView: UIView {
    
    // MARK: - Properties

    let layout = WaterfallLayout()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(
            GalleryViewCell.self,
            forCellWithReuseIdentifier: GalleryViewCell.reuseIdentifier
        )
        
        return collection
    }()
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Methods
    
    func setupLayoutDelegate(_ delegate: WaterfallLayoutDelegate) {
        layout.delegate = delegate
    }
    
    func setupCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func setupCollectionViewDelegate(_ delegate: UICollectionViewDelegate) {
        collectionView.delegate = delegate
    }
    
    func update() {
        collectionView.reloadData()
        layout.updateLayout()
    }
    
    func reload() {
        layout.reloadLayout()
    }
    
    func willTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.updateNumberOfColumns(to: size)
        }, completion: nil)
    }
    
    func updateNumberOfColumns(to size: CGSize) {
        
        if size.width > 1000 {
            layout.numberOfColumns = 4
        } else if size.width > 750 {
            layout.numberOfColumns = 3
        } else {
            layout.numberOfColumns = 2
        }
        
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        reload()
    }
    
    private func configure() {
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    private func setupView() {
        backgroundColor = .appBackground
    }
    
    private func addSubviews() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
