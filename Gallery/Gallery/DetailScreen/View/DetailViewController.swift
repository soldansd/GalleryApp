//
//  DetailViewController.swift
//  Gallery
//
//  Created by Даниил Соловьев on 10/03/2025.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let presenter: DetailPresenterProtocol
    
    private var detailView: DetailView? {
        return view as? DetailView
    }
    
    // MARK: - Init
    
    init(presenter: DetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Life cycle
    
    override func loadView() {
        super.loadView()
        view = DetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToInitialPhoto()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        detailView?.willTransition(to: size, with: coordinator)
    }
    
    // MARK: - Methods
    
    private func configureDetailView() {
        detailView?.setupCollectionViewDataSource(self)
        detailView?.setupCollectionViewDelegate(self)
    }
    
    private func scrollToInitialPhoto() {
        if let index = presenter.photos.firstIndex(where: { $0.id == presenter.initialPhoto.id }) {
            let indexPath = IndexPath(item: index, section: 0)
            detailView?.scrollToItem(at: indexPath)
        }
    }
}

// MARK: - DetailViewProtocol

extension DetailViewController: DetailViewProtocol {
    
    func update() {
        detailView?.update()
    }
}

// MARK: - DetailViewCellDelegate

extension DetailViewController: DetailViewCellDelegate {
    
    func likeButtonTapped(for photo: Photo) {
        presenter.updateLikeStatus(photo: photo, isLiked: photo.isLikedByUser)
    }
    
    func backButtonTapped() {
        presenter.closeDetailScreen()
    }
}

// MARK: - UICollectionViewDataSource

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
        
        let id = DetailViewCell.reuseIdentifier
        let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        guard let cell = reusableCell as? DetailViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = presenter.photos[indexPath.item]
        
        cell.update(with: photo)
        cell.delegate = self
        
        presenter.getImage(for: photo) { data in
            guard let data, cell.photo?.id == photo.id else {
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

// MARK: - UICollectionViewDelegateFlowLayout

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
}
