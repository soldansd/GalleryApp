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
    
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: blurEffectView.safeAreaLayoutGuide.bottomAnchor)
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
