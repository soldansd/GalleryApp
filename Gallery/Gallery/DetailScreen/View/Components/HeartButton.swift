//
//  HeartButton.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

import UIKit

final class HeartButton: UIButton {
    
    // MARK: - Properties
    
    private var isLiked: Bool
    
    // MARK: - Init

    init(isLiked: Bool = false) {
        self.isLiked = isLiked
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Life cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
    
    // MARK: - Methods
    
    func update(isLiked: Bool) {
        self.isLiked = isLiked
        if isLiked {
            tintColor = .red
            setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            tintColor = .label
            setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func setupButton() {
        backgroundColor = .appBackground
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        update(isLiked: isLiked)
        
        addTarget(self, action: #selector(toggle), for: .touchUpInside)
    }
    
    @objc private func toggle() {
        update(isLiked: !isLiked)
    }
}
