//
//  WaterfallLayout.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/17.
//

import UIKit

@objc public protocol UICollectionViewDelegateWaterfallLayout: UICollectionViewDelegate {
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       sizeForItemAt indexPath: IndexPath) -> CGSize
    
    @objc optional func collectionView(_ collectionView: UICollectionView, 
                                       layout collectionViewLayout: WaterfallLayout,
                                       columnCountForSection section: Int) -> Int
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       heightForHeaderInSection section: Int) -> Double
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       heightForFooterInSection section: Int) -> Double
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       insetForSection section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       insetForHeaderInSection section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       insetForFooterInSection section: Int) -> UIEdgeInsets
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       columnSpacingForSection section: Int) -> Double
    
    @objc optional func collectionView(_ collectionView: UICollectionView,
                                       layout collectionViewLayout: WaterfallLayout,
                                       lineSpacingForSection section: Int) -> Double
    
    @objc optional func headerFloatForSections(_ collectionView: UICollectionView,
                                               layout collectionViewLayout: WaterfallLayout) -> [Int]
}

/// 该瀑布流layout与网络上流传的layout写法有些区别，具体表现为：
/// 1.如果header的高度为0，则headerInset不会生效，footer也一样
/// 2.如果section的itemCount为0，则sectionInset不会生效
/// 3.如果section的itemCount为0，则header与headerInset不会生效，footer也一样
/// 4.实现了header的吸顶效果，且能用代理控制生效的sectionList
/// 5.实现了性能优化，没需要的时候不会重新走完整的prepare
/// 性能优化思路参考 https://www.jianshu.com/p/d0ca0ceb706a
open class WaterfallLayout: UICollectionViewLayout {
    
    public static var elementKindSectionHeader = "WaterfallLayout.ElementKindSectionHeader"
    public static var elementKindSectionFooter = "WaterfallLayout.ElementKindSectionFooter"
    
    open var itemSize = CGSizeMake(100, 100) {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var columnCount = 1 {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var headerHeight = 0.0 {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var footerHeight = 0.0 {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var sectionInset = UIEdgeInsets.zero {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var headerInset = UIEdgeInsets.zero {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var footerInset = UIEdgeInsets.zero {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var columnSpacing = 10.0 {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open var lineSpacing = 10.0 {
        didSet {
            isInvalidateAllAttributes = true
            invalidateLayout()
        }
    }
    
    open weak var delegate: (any UICollectionViewDelegateWaterfallLayout)?
    
    //标记是否重新设置所有cell和view的Attributes，也就是执不执行prepare方法
    private var isInvalidateAllAttributes = true
    
    //记录每个section里，每个列的maxY值 [section][columnIndex]
    private var columnMaxY: [[Double]] = []
    
    private var sectionItemAttributes: [Int: [UICollectionViewLayoutAttributes]] = [:]
    
    private var allItemAttributes: [UICollectionViewLayoutAttributes] = []
    
    private var headersAttribute: [Int: UICollectionViewLayoutAttributes] = [:]
    
    private var footersAttribute: [Int: UICollectionViewLayoutAttributes] = [:]
    
    //记录需要吸顶的header的原始位置
    private var needFloatHeaderOrgFrameList: [Int: CGRect] = [:]
    
    open override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        guard let delegate = delegate else { return }
        
        let numberOfSections = collectionView.numberOfSections
        if numberOfSections <= 0 {
            return
        }
        if !delegate.conforms(to: UICollectionViewDelegateWaterfallLayout.self) {
            return
        }
        if columnCount <= 0 && !delegate.responds(to: #selector(delegate.collectionView(_:layout:columnCountForSection:))) {
            return
        }
        
        if !isInvalidateAllAttributes {
            return
        }
        //等待下次刷新所有布局属性的请求
        isInvalidateAllAttributes = false
        
        columnMaxY.removeAll()
        sectionItemAttributes.removeAll()
        allItemAttributes.removeAll()
        headersAttribute.removeAll()
        footersAttribute.removeAll()
        
        let headerFloatSections = headerFloatSections()
        
        for section in 0..<numberOfSections {
            let columnCount = columnCountForSection(section: section)
            var sectioncolumnMaxY = [Double]()
            for _ in 0..<columnCount {
                sectioncolumnMaxY.append(0)
            }
            columnMaxY.append(sectioncolumnMaxY)
        }
        
        var sectionMaxY = 0.0
        let collectionViewWidth = collectionView.frame.size.width
        
        for section in 0..<numberOfSections {
            
            let columnCount = columnCountForSection(section: section)
            let headerHeight = headerHeightForSection(section: section)
            let footerHeight = footerHeightForSection(section: section)
            let sectionInset = insetForSection(section: section)
            let headerInset = headerInsetForSection(section: section)
            let footerInset = footerInsetForSection(section: section)
            let columnSpacing = columnSpacingForSection(section: section)
            let lineSpacing = lineSpacingForSection(section: section)
            
            let width = collectionView.frame.size.width - sectionInset.left - sectionInset.right
            let itemWidth = (width - columnSpacing * Double(columnCount - 1)) / Double(columnCount)
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            //section header
            if itemCount > 0 && headerHeight > 0 {
                sectionMaxY += headerInset.top
                
                let attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: Self.elementKindSectionHeader,
                                                             with: IndexPath(item: 0, section: section))
                attrs.frame = CGRectMake(headerInset.left, sectionMaxY, collectionViewWidth - headerInset.left - headerInset.right, headerHeight)
                headersAttribute[section] = attrs
                allItemAttributes.append(attrs)
                
                if headerFloatSections.contains(section) {
                    needFloatHeaderOrgFrameList[section] = attrs.frame
                }
                sectionMaxY += attrs.frame.size.height + headerInset.bottom
            }
            
            if itemCount > 0 {
                sectionMaxY += sectionInset.top
            }
            
            for idx in 0..<columnCount {
                columnMaxY[section][idx] = sectionMaxY
            }
            
            //section item
            var itemAtts = [UICollectionViewLayoutAttributes]()
            for idx in 0..<itemCount {
                let indexPath = IndexPath(row: idx, section: section)
                let columnIndex = shortestColumnIndex(inSection: section)
                let x = sectionInset.left + (itemWidth + columnSpacing) * Double(columnIndex)
                let y = columnMaxY[section][columnIndex]
                let itemSize = itemSizeForIndexPath(indexPath: indexPath)
                let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attrs.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                itemAtts.append(attrs)
                allItemAttributes.append(attrs)
                columnMaxY[section][columnIndex] = attrs.frame.maxY + lineSpacing
            }
            sectionItemAttributes[section] = itemAtts
            
            if itemCount > 0 {
                let longestColumnIndex = longestColumnIndex(inSection: section)
                sectionMaxY = columnMaxY[section][longestColumnIndex] - lineSpacing + sectionInset.bottom
            }
            
            //section footer
            if itemCount > 0 && footerHeight > 0 {
                sectionMaxY += footerInset.top
                
                let attrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: Self.elementKindSectionFooter,
                                                             with: IndexPath(item: 0, section: section))
                attrs.frame = CGRectMake(footerInset.left, sectionMaxY, collectionViewWidth - footerInset.left - footerInset.right, footerHeight)
                footersAttribute[section] = attrs
                allItemAttributes.append(attrs)
                
                sectionMaxY += attrs.frame.size.height + footerInset.bottom
            }
            
            for idx in 0..<columnCount {
                columnMaxY[section][idx] = sectionMaxY
            }
        }
        //reloadData后要重新处理吸顶header的frame
        handleHeaderFloat(newBounds: collectionView.bounds, context: nil)
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if indexPath.section > sectionItemAttributes.count {
            return nil
        }
        let sectionAttrsList = sectionItemAttributes[indexPath.section]!
        if indexPath.row > sectionAttrsList.count {
            return nil
        }
        return sectionAttrsList[indexPath.row]
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attrs: UICollectionViewLayoutAttributes?
        if elementKind == Self.elementKindSectionHeader {
            attrs = headersAttribute[indexPath.section]
        } else if elementKind == Self.elementKindSectionFooter {
            attrs = footersAttribute[indexPath.section]
        }
        return attrs
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attrsList = [UICollectionViewLayoutAttributes]()
        for attrs in allItemAttributes {
            if rect.intersects(attrs.frame) {
                attrsList.append(attrs)
            }
        }
        return attrsList
    }
    
    open override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else { return .zero }
        let width = collectionView.frame.size.width
        let height = columnMaxY.last?.first ?? 0.0
        return CGSizeMake(width, height)
    }
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        if collectionView.bounds.size.width != newBounds.size.width {
            isInvalidateAllAttributes = true
            return true
        } else if collectionView.bounds.origin.y != newBounds.origin.y {
            //滚动的时候询问是否有需要刷新布局
            return true
        }
        return false
    }
    
    open override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
        let context = super.invalidationContext(forBoundsChange: newBounds)
        handleHeaderFloat(newBounds: newBounds, context: context)
        return context
    }
    
    open override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateEverything {
            isInvalidateAllAttributes = true
        }
        super.invalidateLayout(with: context)
    }
    
    func handleHeaderFloat(newBounds: CGRect, context: UICollectionViewLayoutInvalidationContext?) {
        //根据newBounds，计算出需要吸顶的section，-1表示当前没有需要吸顶的section
        let section = checkNeedFloatHeaderSection(newBounds: newBounds)
        //处理吸顶section的header的frame
        handleHeaderFloatFrame(section: section, newBounds: newBounds, context: context)
        //其他header如果不在原位置，则恢复到原本的位置
        resetOtherHeaderFrame(floatingHeaderSection: section, context: context)
    }
    
    func checkNeedFloatHeaderSection(newBounds: CGRect) -> Int {
        guard let maxY = columnMaxY.last?.first else {
            return -1
        }
        if newBounds.origin.y < 0 || newBounds.origin.y > maxY {
            return -1
        }
        var headerFloatSection = -1
        for (section, headerOrgFrame) in needFloatHeaderOrgFrameList {
            guard let sectionMaxY = columnMaxY[section].first else { continue }
            if newBounds.origin.y > headerOrgFrame.origin.y && newBounds.origin.y < sectionMaxY {
                headerFloatSection = section
            }
        }
        return headerFloatSection
    }
    
    func handleHeaderFloatFrame(section: Int, newBounds: CGRect, context: UICollectionViewLayoutInvalidationContext?) {
        if section < 0 {
            return
        }
        guard let columnMaxY = columnMaxY[section].first else { return }
        let attrs = headersAttribute[section]!
        let frame = attrs.frame
        if newBounds.origin.y < columnMaxY - frame.size.height {
            attrs.frame = CGRect(x: frame.origin.x, y: newBounds.origin.y, width: frame.width, height: frame.height)
        } else {
            attrs.frame = CGRect(x: frame.origin.x, y: columnMaxY - frame.size.height, width: frame.width, height: frame.height)
        }
        attrs.zIndex = Int.max
        context?.invalidateSupplementaryElements(ofKind: Self.elementKindSectionHeader, at: [IndexPath(row: 0, section: section)])
    }
    
    func resetOtherHeaderFrame(floatingHeaderSection: Int, context: UICollectionViewLayoutInvalidationContext?) {
        for (section, attrs) in headersAttribute {
            if section != floatingHeaderSection {
                if let orgFrame = needFloatHeaderOrgFrameList[section] {
                    if !attrs.frame.equalTo(orgFrame) {
                        attrs.frame = orgFrame
                        context?.invalidateSupplementaryElements(ofKind: Self.elementKindSectionHeader, 
                                                                 at: [IndexPath(row: 0, section: section)])
                    }
                }
            }
        }
    }
}

//MARK: 其他方法
extension WaterfallLayout {
    
    func shortestColumnIndex(inSection section: Int) -> Int {
        var index = 0
        var shortestHeight = Double.infinity
        let columnMaxY = columnMaxY[section]
        for (idx, height) in columnMaxY.enumerated() {
            if height < shortestHeight {
                shortestHeight = height
                index = idx
            }
        }
        return index
    }
    
    func longestColumnIndex(inSection section: Int) -> Int {
        var index = 0
        var longestHeight = 0.0
        let columnMaxY = columnMaxY[section]
        for (idx, height) in columnMaxY.enumerated() {
            if height > longestHeight {
                longestHeight = height
                index = idx
            }
        }
        return index
    }
    
    func itemSizeForIndexPath(indexPath: IndexPath) -> CGSize {
        var size: CGSize = .zero
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:sizeForItemAt:))) {
            size = delegate.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
        } else {
            size = itemSize
        }
        return size
    }
    
    func columnCountForSection(section: Int) -> Int {
        var count = 0
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:columnCountForSection:))) {
            count = delegate.collectionView!(collectionView, layout: self, columnCountForSection: section)
        } else {
            count = columnCount
        }
        return count
    }
    
    func headerHeightForSection(section: Int) -> Double {
        var height = 0.0
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:heightForHeaderInSection:))) {
            height = delegate.collectionView!(collectionView, layout: self, heightForHeaderInSection: section)
        } else {
            height = headerHeight
        }
        return height
    }
    
    func footerHeightForSection(section: Int) -> Double {
        var height = 0.0
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:heightForFooterInSection:))) {
            height = delegate.collectionView!(collectionView, layout: self, heightForFooterInSection: section)
        } else {
            height = footerHeight
        }
        return height
    }
    
    func insetForSection(section: Int) -> UIEdgeInsets {
        var edge: UIEdgeInsets = .zero
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:insetForSection:))) {
            edge = delegate.collectionView!(collectionView, layout: self, insetForSection: section)
        } else {
            edge = sectionInset
        }
        return edge
    }
    
    func headerInsetForSection(section: Int) -> UIEdgeInsets {
        var edge: UIEdgeInsets = .zero
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:insetForHeaderInSection:))) {
            edge = delegate.collectionView!(collectionView, layout: self, insetForHeaderInSection: section)
        } else {
            edge = headerInset
        }
        return edge
    }
    
    func footerInsetForSection(section: Int) -> UIEdgeInsets {
        var edge: UIEdgeInsets = .zero
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:insetForFooterInSection:))) {
            edge = delegate.collectionView!(collectionView, layout: self, insetForFooterInSection: section)
        } else {
            edge = footerInset
        }
        return edge
    }
    
    func columnSpacingForSection(section: Int) -> Double {
        var spacing = 0.0
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:columnSpacingForSection:))) {
            spacing = delegate.collectionView!(collectionView, layout: self, columnSpacingForSection: section)
        } else {
            spacing = columnSpacing
        }
        return spacing
    }
    
    func lineSpacingForSection(section: Int) -> Double {
        var spacing = 0.0
        if let delegate = delegate,
           let collectionView = collectionView,
            delegate.responds(to: #selector(delegate.collectionView(_:layout:lineSpacingForSection:))) {
            spacing = delegate.collectionView!(collectionView, layout: self, lineSpacingForSection: section)
        } else {
            spacing = lineSpacing
        }
        return spacing
    }
    
    func headerFloatSections() -> [Int] {
        var sections = [Int]()
        if let delegate = delegate,
           let collectionView = collectionView,
           delegate.responds(to: #selector(delegate.headerFloatForSections(_:layout:))) {
            sections = delegate.headerFloatForSections!(collectionView, layout: self)
        } else {
            sections = []
        }
        return sections
    }
}
