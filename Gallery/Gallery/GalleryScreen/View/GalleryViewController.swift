//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    // MARK: - Properties
    
    let presenter: GalleryPresenterProtocol
    
    private var galleryView: GalleryView? {
        return view as? GalleryView
    }
    
    private var lastTransitionSize: CGSize = .zero
    
    // MARK: - Init
    
    init(presenter: GalleryPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        view = GalleryView()
        print(#function)
        print(presenter.observedNotification)
        print(view.bounds.size)
        print()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.initialLoad()
        configureGalleryView()
        print(#function)
        print(presenter.observedNotification)
        print(view.bounds.size)
        print()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        galleryView?.updateNumberOfColumns(to: lastTransitionSize)
        print(#function)
        print(presenter.observedNotification)
        print(view.bounds.size)
        print()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        galleryView?.willTransition(to: size, with: coordinator)
        lastTransitionSize = size
        print(#function)
        print(presenter.observedNotification)
        print(size)
        print()
    }
    
    // MARK: - Methods
    
    private func configureGalleryView() {
        galleryView?.setupCollectionViewDataSource(self)
        galleryView?.setupCollectionViewDelegate(self)
        galleryView?.setupLayoutDelegate(self)
    }
}

// MARK: - GalleryViewProtocol

extension GalleryViewController: GalleryViewProtocol {
    
    func update() {
        galleryView?.update()
    }
    
    func reload() {
        galleryView?.reload()
    }
}

// MARK: - WaterfallLayoutDelegate

extension GalleryViewController: WaterfallLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let galleryView else { return 0 }
        
        let photoWidth = galleryView.layout.columnWidth
        let photo = presenter.photos[indexPath.item]
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let cellHeight = photoWidth * aspectRatio
        
        return cellHeight
    }
}

// MARK: - UICollectionViewDataSource

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
        
        let id = GalleryViewCell.reuseIdentifier
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        guard let cell = reusableCell as? GalleryViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = presenter.photos[indexPath.item]
        let photoId = photo.id
        cell.update(with: photo)
        
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

// MARK: - UICollectionViewDelegate

extension GalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.openDetailScreen(for: presenter.photos[indexPath.item], photos: presenter.photos)
    }
}
