//
//  DetailViewController.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

protocol DetailViewProtocol: AnyObject {
    
    func update()
}

class DetailViewController: UIViewController, DetailViewProtocol {
    
    let presenter: DetailPresenterProtocol
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.estimatedItemSize = .zero
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.contentInsetAdjustmentBehavior = .never
        collection.register(
            DetailPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailPhotoCollectionViewCell.reuseIdentifier
        )
        return collection
    }()
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        scrollToSelectedPhoto()
    }
    
    private func scrollToSelectedPhoto() {
        if let index = presenter.photos.firstIndex(where: { $0.id == presenter.currentPhoto.id }) {
            let indexPath = IndexPath(item: index, section: 0)
            //collectionView.reloadData()
            collectionView.layoutIfNeeded()
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let visibleIndexPath = collectionView.indexPathsForVisibleItems.first else {
                super.viewWillTransition(to: size, with: coordinator)
                return
            }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.collectionView.reloadData()
            self?.collectionView.layoutIfNeeded()
            //self?.collectionView.collectionViewLayout.invalidateLayout()
            self?.collectionView.scrollToItem(at: visibleIndexPath, at: .centeredHorizontally, animated: false)
        }, completion: nil)
        
        super.viewWillTransition(to: size, with: coordinator)
        
    }
    
    func update() {
        collectionView.reloadData()
    }
    
}

extension DetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.item == presenter.photos.count - 1 {
            presenter.loadNextPage()
        }
        
        let id = DetailPhotoCollectionViewCell.reuseIdentifier
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        guard let cell = reusableCell as? DetailPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = presenter.photos[indexPath.item]
        cell.configure(with: photo)
        
        let photoId = photo.id
        cell.photoId = photoId
        cell.likeButtonTapped = { [weak self] in
            self?.presenter.updateLikeStatus(photo: photo, isLiked: !photo.isLikedByUser)
        }
        cell.backButtonTapped = { [weak self] in
            self?.presenter.closeDetailScreen()
        }
        
        presenter.getImage(for: photo) { data in
            guard let data, cell.photoId == photoId else {
                return
            }
            
            guard let image = UIImage(data: data) else {
                return
            }
            
            cell.setImage(image)
        }
        
        return cell
    }
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
}
