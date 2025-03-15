//
//  WaterfallLayoutDelegate.swift
//  Gallery
//
//  Created by Даниил Соловьев on 15/03/2025.
//

import UIKit

protocol WaterfallLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
}
