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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        presenter.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { nil }
    
    func update() {
        collectionView.reloadData()
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
        
        let id = GalleryPhotoCollectionViewCell.reuseIdentifier
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        let cell = reusableCell as? GalleryPhotoCollectionViewCell
        
        cell?.configure(with: UIImage(systemName: "picture"))
        
        let photo = presenter.photos[indexPath.item]
        
        if let data = CacheManager.shared.getImageData(forKey: photo.id) {
            cell?.configure(with: UIImage(data: data))
        } else {
            NetworkManager.shared.getImage(from: photo.imageURL) { result in
                guard case .success(let data) = result else {
                    return
                }
                
                CacheManager.shared.saveImageData(data, forKey: photo.id)
                
                let image = UIImage(data: data)
                
                DispatchQueue.main.async {
                    cell?.configure(with: image)
                }
            }
        }
        
        return cell ?? UICollectionViewCell()
    }
}

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let photo = presenter.photos[indexPath.item]
        
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let cellHeight = screenWidth * aspectRatio
        
        return CGSize(width: screenWidth, height: cellHeight)
    }
}
