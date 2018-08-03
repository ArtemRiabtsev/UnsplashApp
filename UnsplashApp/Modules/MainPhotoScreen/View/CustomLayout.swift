//
//  CustomLayout.swift
//  UnsplashApp
//
//  Created by Артем Рябцев on 04.07.2018.
//  Copyright © 2018 Артем Рябцев. All rights reserved.
//

import UIKit

protocol UnsplashLayoutDelegate: class {
    func collectionView(_collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}

class CustomLayout: UICollectionViewLayout {
    // 1
    weak var delegate: UnsplashLayoutDelegate!
    // 2
    var numberOfColumns = 1
    var cellPadding: CGFloat = 10
    // 3
    var cache = [UICollectionViewLayoutAttributes]()
    // 4
    var contentHeight: CGFloat = 0
    
    var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    // 5
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        //1
        guard let collectionView = collectionView else {
            return
        }
        //2
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset = [CGFloat]()
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
        //3
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            //4
            let photoHeight = delegate.collectionView(_collectionView: collectionView, heightForPhotoAtIndexPath: indexPath)
            
            let height = cellPadding * 2 + photoHeight
            
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            // 5
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            // 6
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(indexPath.item)
        return cache[indexPath.item]
    }
 
}
