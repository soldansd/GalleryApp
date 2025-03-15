//
//  InfoLabel.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

import UIKit

final class InfoLabel: UILabel {
    
    //MARK: - Properties
    
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
    
    //MARK: - Init

    init(header: String) {
        self.headerText = header
        super.init(frame: .zero)
        setupLabel()
    }
    
    required init?(coder: NSCoder) { return nil }
    
    //MARK: - Methods

    func updateAttributedText() {
        guard let text, !text.isEmpty else {
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
    
    private func setupLabel() {
        font = .openSans(size: 16)
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
}
