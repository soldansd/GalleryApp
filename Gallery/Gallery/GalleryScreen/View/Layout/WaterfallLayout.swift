//
//  WaterfallLayout.swift
//  Gallery
//
//  Created by Даниил Соловьев on 11/03/2025.
//

import UIKit

final class WaterfallLayout: UICollectionViewLayout {
    
    // MARK: - Properties
    
    weak var delegate: WaterfallLayoutDelegate?
    
    var numberOfColumns = 2 {
        didSet {
            updateLayout()
        }
    }
    
    var columnWidth: CGFloat {
       return (width - CGFloat(numberOfColumns + 1) * cellPadding) / CGFloat(numberOfColumns)
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    private var contentHeight: CGFloat = 0
    
    private let cellPadding: CGFloat = 8
    
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var lastAttributesForColumn: [UICollectionViewLayoutAttributes?] = []

    private var previousCountOfElements = 0
    private var shouldUpdateLayout = true
    
    private var width: CGFloat {
        print("WaterfallLayout - width")
        print(collectionView?.bounds.width ?? .zero)
        print()
        return collectionView?.bounds.width ?? .zero
    }
    
    private var xOffsetForColumn: [CGFloat] {
        return (0..<numberOfColumns).map { CGFloat($0) * (columnWidth + cellPadding) + cellPadding }
    }
    
    // MARK: - Methods
    
    func updateLayout() {
        shouldUpdateLayout = true
        invalidateLayout()
    }
    
    func reloadLayout() {
        previousCountOfElements = 0
        attributes = []
        lastAttributesForColumn = Array(repeating: nil, count: numberOfColumns)
    }
    
    override func prepare() {
        guard shouldUpdateLayout, let collectionView else { return }
        
        let firstNewItem = previousCountOfElements
        let lastNewItem = collectionView.numberOfItems(inSection: 0)
        
        for item in firstNewItem..<lastNewItem {
            
            let indexPath = IndexPath(item: item, section: 0)
            let height = delegate?.collectionView(collectionView, heightForItemAtIndexPath: indexPath) ?? 0
            
            let yOffsetForColumn = lastAttributesForColumn.map { ($0?.frame.maxY ?? 0) + cellPadding }
            
            let shortestColumn = yOffsetForColumn.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
            
            let frame = CGRect(
                x: xOffsetForColumn[shortestColumn],
                y: yOffsetForColumn[shortestColumn],
                width: columnWidth,
                height: height
            )
            
            let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            cellAttributes.frame = frame
            attributes.append(cellAttributes)
            
            lastAttributesForColumn[shortestColumn] = cellAttributes
            contentHeight = max(contentHeight, frame.maxY)
        }
        
        previousCountOfElements = attributes.count
        shouldUpdateLayout = false
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes.filter { $0.frame.intersects(rect) }
    }
}
