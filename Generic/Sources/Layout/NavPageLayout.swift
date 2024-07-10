//
//  NavPageLayout.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/11.
//

import UIKit

open class NavPageLayout: UICollectionViewFlowLayout {
    
    open var perRowItemCount = 5
    
    open var rowCount = 2

    open var allAttrs: [UICollectionViewLayoutAttributes] = []

    open override func prepare() {
        super.prepare()
        
        guard let collectionView = self.collectionView else { return }
        guard let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout else { return }
        
        collectionView.isPagingEnabled = true
        
        let collectionViewWidth = collectionView.frame.size.width
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let lineSpacing = delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: 0) ?? 0
        let itemSpacing = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: 0) ?? 0
        let sectionInset = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: 0) ?? .zero
        
        self.allAttrs.removeAll()
        for idx in 0..<itemCount {
            let inPageIndex = idx % (perRowItemCount * rowCount)
            let inRowIndex = idx % perRowItemCount
            let curPage = lround(floor(Double(idx) / Double(perRowItemCount * rowCount)))
            let curRow = lround(floor(Double(inPageIndex) / Double(perRowItemCount)))
            
            let indexPath = IndexPath(row: idx, section: 0)
    
            let itemSize = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero
            
            let x = sectionInset.left + collectionViewWidth * Double(curPage) + (itemSize.width + itemSpacing) * Double(inRowIndex)
            let y = itemSize.height * Double(curRow) + lineSpacing * Double(curRow)
            let frame = CGRect(x: x,
                               y: y,
                               width: itemSize.width,
                               height: itemSize.height)
            
            let attrs = self.layoutAttributesForItem(at: indexPath)
            attrs?.frame = frame
            if let attrs = attrs {
                self.allAttrs.append(attrs)
            }
        }
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = self.collectionView else { return .zero }
        
        let collectionViewWidth = collectionView.frame.size.width
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let pageCount = lround(ceil(Double(itemCount) / Double(perRowItemCount * rowCount)))
        let size = CGSize(width: collectionViewWidth * Double(pageCount), height: collectionView.frame.size.height)
        return size
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrsList = [UICollectionViewLayoutAttributes]()
        for attrs in allAttrs {
            if rect.intersects(attrs.frame) {
                attrsList.append(attrs)
            }
        }
        return attrsList
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.row >= allAttrs.count {
            return super.layoutAttributesForItem(at: indexPath)
        }
        return allAttrs[indexPath.row]
    }
}

