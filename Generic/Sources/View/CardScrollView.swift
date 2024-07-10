//
//  CardScrollView.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/7/7.
//

import UIKit

@objc public protocol CardScrollViewDelegate: NSObjectProtocol {
    
    func numberOfItem(in cardScrollView :CardScrollView) -> Int
    
    func cardScrollView(_ cardScrollView: CardScrollView, itemForIndex index: Int) -> UIView
    
    func cardScrollView(_ cardScrollView: CardScrollView, didSelectedIndex index: Int) -> Void
}


open class CardScrollView: BaseView {
    
    public var option = CardScrollViewOption()
    
    public var scrollSize = CGSizeMake(320, 145)
    
    public var itemSize = CGSizeMake(305, 145)
    
    public var itemSpacing: Double {
        get {
            let num = scrollSize.width - itemSize.width
            return num
        }
    }
    
    public var isLoop = false
    
    public var scrollView: UIScrollView!
    
    public weak var delegate: (any CardScrollViewDelegate)?
    
    public var itemList: [UIView] = []
    
    public var didScrollToIndex: ((CardScrollView, Int) -> Void)?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initailization()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initailization()
    }
    
    func initailization() {
        backgroundColor = .clear
        clipsToBounds = true
        
        scrollView = {
            let sv = UIScrollView.init()
            sv.showsVerticalScrollIndicator = false
            sv.showsHorizontalScrollIndicator = false
            sv.isPagingEnabled = true
            sv.clipsToBounds = false
            sv.backgroundColor = .clear
            sv.delegate = self
            return sv
        }()
        addSubview(scrollView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(tap:)))
        scrollView.addGestureRecognizer(tap)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(x: 0, y: 0, width: scrollSize.width, height: scrollSize.height)
        scrollView.center = CGPoint(x: self.frame.width / 2.0 + itemSpacing / 2.0,
                                    y: self.frame.height / 2.0)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: kScreenWidth, height: scrollSize.height)
    }
    
    public func refresh() {
        guard let delegate = delegate else { return }
        guard delegate.responds(to: #selector(delegate.numberOfItem(in:))) else {
            return
        }
        guard delegate.responds(to: #selector(delegate.cardScrollView(_:itemForIndex:))) else {
            return
        }
        for view in scrollView.subviews {
            view.removeFromSuperview()
        }
        itemList.removeAll()
        let itemCount = delegate.numberOfItem(in: self)
        if itemCount <= 0 {
            return
        }
        
        for i in 0..<itemCount {
            let item = delegate.cardScrollView(self, itemForIndex: i)
            scrollView.addSubview(item)
            itemList.append(item)
        }
        if isLoop {
            let itemBegin = delegate.cardScrollView(self, itemForIndex: itemCount - 1)
            let itemEnd1 = delegate.cardScrollView(self, itemForIndex: 0)
            var itemEnd2: UIView?
            if itemCount >= 2 {
                itemEnd2 = delegate.cardScrollView(self, itemForIndex: 1)
            } else if itemCount >= 1 {
                itemEnd2 = delegate.cardScrollView(self, itemForIndex: 0)
            }
            scrollView.addSubview(itemBegin)
            scrollView.addSubview(itemEnd1)
            scrollView.addSubview(itemEnd2!)
            itemList.insert(itemBegin, at: 0)
            itemList.append(itemEnd1)
            itemList.append(itemEnd2!)
        }
        
        for i in 0..<itemList.count {
            let item = itemList[i]
            let x = (itemSize.width + itemSpacing) * Double(i)
            let y = (scrollSize.height - itemSize.height) / 2
            item.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
        }
        
        if isLoop {
            scrollView.contentSize = CGSize(width: scrollSize.width * Double(itemCount + 3),
                                            height: scrollSize.height)
        } else {
            scrollView.contentSize = CGSize(width: scrollSize.width * Double(itemCount),
                                            height: scrollSize.height)
        }
    }
    
    public func reloadData() {
        refresh()
        if isLoop {
            scrollView.setContentOffset(CGPoint(x: scrollSize.width, y: 0), animated: false)
        }
        handleItemTransform()
    }
    
    public func scrollToIndex(_ index: Int) {
        guard let delegate = delegate else { return }
        let itemCount = delegate.numberOfItem(in: self)
        if index < 0 || index >= itemCount {
            return
        }
        let logicIndex = index
        let index = logicIndexToIndex(logicIndex: logicIndex)
        scrollView.setContentOffset(CGPoint(x: Double(index) * scrollSize.width, y: 0), animated: true)
    }
    
    public func getItemLogicIndex(item: UIView) -> Int {
        guard itemList.contains(where: {$0 === item}) else {
            return -1
        }
        let index = itemList.firstIndex(of: item)! - itemList.startIndex
        let logicIndex = indexToLogicIndex(index: index)
        return logicIndex
    }
    
    func indexToLogicIndex(index: Int) -> Int {
        guard index >= 0 && index < itemList.count else { return -1 }
        guard let delegate = delegate else { return -1 }
        let itemCount = delegate.numberOfItem(in: self)
        var logicIndex = index
        if isLoop {
            logicIndex -= 1
            if logicIndex == -1 {
                logicIndex = itemCount - 1
            } else if logicIndex == itemCount {
                logicIndex = 0
            } else if logicIndex == itemCount + 1 {
                logicIndex = 1
            }
        }
        return logicIndex
    }
    
    func logicIndexToIndex(logicIndex: Int) -> Int {
        var index = logicIndex
        if isLoop {
            index += 1
        }
        return index
    }
}

extension CardScrollView {
    
    @objc func didTap(tap: UITapGestureRecognizer) {
        guard let delegate = delegate else { return }
        guard delegate.responds(to: #selector(delegate.cardScrollView(_:didSelectedIndex:))) else {
            return
        }
        let loc = tap.location(in: scrollView)
        var tapItem: UIView?
        for item in itemList {
            if item.frame.contains(loc) {
                tapItem = item
                break
            }
        }
        if let tapItem = tapItem {
            let index = itemList.firstIndex(of: tapItem)! - itemList.startIndex
            let logicIndex = indexToLogicIndex(index: index)
            delegate.cardScrollView(self, didSelectedIndex: logicIndex)
        }
    }
}

extension CardScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = lround(scrollView.contentOffset.x / scrollSize.width)
        let itemCount = itemList.count
        if index < 0 || index >= itemCount {
            return
        }
        let logicIndex = indexToLogicIndex(index: index)
        didScrollToIndex?(self, logicIndex)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isLoop {
            guard let delegate = delegate else { return }
            let itemCount = delegate.numberOfItem(in: self)
            var offsetX = scrollView.contentOffset.x
            if offsetX > scrollSize.width * Double(itemCount + 1) {
                let offsetEx = offsetX - (scrollSize.width * Double(itemCount + 1))
                offsetX = scrollSize.width + offsetEx
            } else if offsetX < scrollSize.width {
                let offsetEx = (offsetX - scrollSize.width)
                offsetX = scrollSize.width * Double(itemCount + 1) + offsetEx
            }
            scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        }
        handleItemTransform()
    }
}

extension CardScrollView {
    
    func handleItemTransform() {
        let offsetX = scrollView.contentOffset.x
        if option.style == .scale {
            handleItemTransformForScale(offsetX: offsetX)
        } else if #available(iOS 13, *), option.style == .yRotation {
            handleItemTransformForYRotation(offsetX: offsetX)
        }
    }
    
    func handleItemTransformForScale(offsetX: Double) {
        var leftIdx = -1
        var rightIdx = -1
        var leftOriginX = -Double.infinity
        var rightOriginX = Double.infinity
        for idx in 0..<itemList.count {
            let item = itemList[idx]
            if item.frame.origin.x <= offsetX && 
                item.frame.origin.x >= leftOriginX {
                leftOriginX = item.frame.origin.x
                leftIdx = idx
            } else if item.frame.origin.x > offsetX &&
                        item.frame.origin.x < rightOriginX {
                rightOriginX = item.frame.origin.x
                rightIdx = idx
            }
        }
        
        let minSale = option.minScale
        if leftIdx != -1 {
            let leftItem = itemList[leftIdx]
            let scale = 1 - (abs(Double(leftIdx) * scrollSize.width - offsetX) / scrollSize.width) * (1 - minSale)
            leftItem.transform = CGAffineTransformScale(CGAffineTransform.identity, scale, scale)
        }
        if rightIdx != -1 {
            let rightItem = itemList[rightIdx]
            let scale = 1 - (abs(Double(rightIdx) * scrollSize.width - offsetX) / scrollSize.width) * (1 - minSale)
            rightItem.transform = CGAffineTransformScale(CGAffineTransform.identity, scale, scale)
        }
        for idx in 0..<itemList.count {
            let item = itemList[idx]
            if idx != leftIdx && idx != rightIdx {
                item.transform = CGAffineTransformScale(CGAffineTransform.identity, minSale, minSale)
            }
        }
    }
    
    func handleItemTransformForYRotation(offsetX: Double) {
        if #available(iOS 13, *) {
            var leftIdx = -1
            var rightIdx = -1
            var leftOriginX = -Double.infinity
            var rightOriginX = Double.infinity
            for idx in 0..<itemList.count {
                let item = itemList[idx]
                if item.frame.origin.x <= offsetX &&
                    item.frame.origin.x >= leftOriginX {
                    leftOriginX = item.frame.origin.x
                    leftIdx = idx
                } else if item.frame.origin.x > offsetX &&
                            item.frame.origin.x < rightOriginX {
                    rightOriginX = item.frame.origin.x
                    rightIdx = idx
                }
            }
            
            let maxAngle = Double.pi / 180.0 * option.maxAngle
            let m34 = option.m34
            if leftIdx != -1 {
                let leftItem = itemList[leftIdx]
                let angle = (abs(Double(leftIdx) * scrollSize.width - offsetX) / scrollSize.width) * maxAngle
                var transform = CATransform3DIdentity
                transform.m34 = m34
                transform = CATransform3DRotate(transform, angle, 0, 1, 0)
                leftItem.transform3D = transform
            }
            if rightIdx != -1 {
                let rightItem = itemList[rightIdx]
                let angle = (abs(Double(rightIdx) * scrollSize.width - offsetX) / scrollSize.width) * maxAngle
                var transform = CATransform3DIdentity
                transform.m34 = m34
                transform = CATransform3DRotate(transform, -angle, 0, 1, 0)
                rightItem.transform3D = transform
            }
            for idx in 0..<itemList.count {
                let item = itemList[idx]
                if leftIdx != -1 && idx < leftIdx {
                    var transform = CATransform3DIdentity
                    transform.m34 = m34
                    transform = CATransform3DRotate(transform, maxAngle, 0, 1, 0)
                    item.transform3D = transform
                } else if rightIdx != -1 && idx > rightIdx {
                    var transform = CATransform3DIdentity
                    transform.m34 = m34
                    transform = CATransform3DRotate(transform, -maxAngle, 0, 1, 0)
                    item.transform3D = transform
                }
            }
        }
    }
}


open class CardScrollViewOption {
    /// 切换效果
    public var style: CardScrollViewStyle = .translation
    /// 最小scale，style = .scale 时有效
    public var minScale = 0.9
    /// 最大旋转角度 style = .yRotation 时有效
    public var maxAngle = 35.0
    /// 景深 style = .yRotation 时有效
    public var m34 = -1 / 400.0
}

public enum CardScrollViewStyle {
    /// 平移
    case translation
    /// 缩放
    case scale
    /// 绕y轴旋转一定角度
    @available(iOS 13.0, *)
    case yRotation
}
