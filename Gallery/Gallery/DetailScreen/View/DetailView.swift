//
//  DetailView.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

import UIKit

final class DetailView: UIView {
    
    //MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(
            DetailViewCell.self,
            forCellWithReuseIdentifier: DetailViewCell.reuseIdentifier
        )
        return collection
    }()
    
    private let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = .zero
        return layout
    }()
    
    //MARK: - Init
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) { nil }
    
    //MARK: - Methods
    
    func setupCollectionViewDataSource(_ dataSource: UICollectionViewDataSource) {
        collectionView.dataSource = dataSource
    }
    
    func setupCollectionViewDelegate(_ delegate: UICollectionViewDelegateFlowLayout) {
        collectionView.delegate = delegate
    }
    
    func update() {
        collectionView.reloadData()
    }
    
    func scrollToItem(at indexPath: IndexPath) {
        collectionView.layoutIfNeeded()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    func willTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if let visibleIndexPath = collectionView.indexPathsForVisibleItems.first {
            coordinator.animate(alongsideTransition: { [weak self] _ in
                self?.scrollToItem(at: visibleIndexPath)
            }, completion: nil)
        }
    }
    
    private func configure() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(collectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
