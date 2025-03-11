//
//  WaterfallLayout.swift
//  Gallery
//
//  Created by Даниил Соловьев on 11/03/2025.
//

import UIKit

protocol WaterfallLayoutDelegate: AnyObject {
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}

class WaterfallLayout: UICollectionViewLayout {
    
    weak var delegate: WaterfallLayoutDelegate?
    
    var numberOfColumns = 2 {
        didSet {
            updateLayout()
        }
    }
    
    private let cellPadding: CGFloat = 8
    private var contentHeight: CGFloat = 0
    
    private var attributes: [UICollectionViewLayoutAttributes] = []
    private var lastAttributesForColumn: [UICollectionViewLayoutAttributes?] = []

    private var previousCountOfElements = 0
    private var shouldUpdateLayout = true
    
    
    private var width: CGFloat {
        return collectionView?.bounds.width ?? .zero
    }
    
    var columnWidth: CGFloat {
       return (width - CGFloat(numberOfColumns + 1) * cellPadding) / CGFloat(numberOfColumns)
    }
    
    private var xOffsetForColumn: [CGFloat] {
        return (0..<numberOfColumns).map { CGFloat($0) * (columnWidth + cellPadding) + cellPadding }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    func updateLayout() {
        shouldUpdateLayout = true
        invalidateLayout()
    }
    
    override func prepare() {
        guard shouldUpdateLayout, let collectionView else { return }
        
        if lastAttributesForColumn.count != numberOfColumns {
            lastAttributesForColumn = Array(repeating: nil, count: numberOfColumns)
        }
        
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
