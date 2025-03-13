//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

protocol GalleryViewProtocol: AnyObject {
    func update()
}

final class GalleryViewController: UIViewController, GalleryViewProtocol {
    
    let presenter: GalleryPresenterProtocol
    
    private lazy var layout: WaterfallLayout = {
        let layout = WaterfallLayout()
        layout.delegate = self
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.dataSource = self
        collection.delegate = self
        collection.register(
            GalleryPhotoCollectionViewCell.self,
            forCellWithReuseIdentifier: GalleryPhotoCollectionViewCell.reuseIdentifier
        )
        
        return collection
    }()
    
    init(presenter: GalleryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    override func viewDidLoad() {
        presenter.viewDidLoad()
        
        view.addSubview(collectionView)
        view.backgroundColor = .appBackground
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            if size.width > size.height {
                // Landscape
                self?.layout.numberOfColumns = 3
            } else {
                // Portrait
                self?.layout.numberOfColumns = 2
            }
            
            self?.collectionView.reloadData()
            self?.collectionView.layoutIfNeeded()
            self?.collectionView.collectionViewLayout.invalidateLayout()
        }, completion: nil)
    }
    
    func update() {
        collectionView.reloadData()
        layout.updateLayout()
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.photos.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        if indexPath.item == presenter.photos.count - 1 {
            presenter.loadNextPage()
        }
        
        let id = GalleryPhotoCollectionViewCell.reuseIdentifier
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        guard let cell = reusableCell as? GalleryPhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = presenter.photos[indexPath.item]
        let photoId = photo.id
        cell.configure(with: photo)
        
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

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openDetailScreen(for: presenter.photos[indexPath.item])
    }
}

extension GalleryViewController: WaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        let photoWidth = layout.columnWidth
        let photo = presenter.photos[indexPath.item]
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let cellHeight = photoWidth * aspectRatio
        
        return cellHeight
    }
}
