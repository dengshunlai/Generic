//
//  CircleLayout.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/13.
//

import UIKit

@objc public protocol UICollectionViewDelegateCircleLayout: UICollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: CircleLayout, isBeginRotation: Bool)
    @objc optional func collectionView(_ collectionView: UICollectionView, layout: CircleLayout, isEndRotation: Bool)
}

open class CircleLayout: UICollectionViewLayout {
    
    /// 每一项的大小
    open var itemSize: CGSize = .zero
    
    /// 转盘每一项的偏移，调整这个属性能改变每一项到转盘中心的距离，默认0，表示cell的外边与转盘内边框相切
    open var itemOffset: Double = 0.0
    
    /// 转动时间
    open var rotationTime = 2.0
    
    /// 转动的最小角度
    open var rotationBaseAngle = 2 * Double.pi
    
    /// 转动的可变角度范围，范围内随机
    open var rotationRangeAngle = 0...2 * Double.pi * 2
    
    /// 转动角度的最小量度，表示最终的转动角度只能是这个角度的整数倍，设置为0表示全角度自由旋转
    /// 一般设置为2 * pi / cellCount 用于对准
    open private(set) var rotationPerAngle = 0.0
    
    /// 是否正在旋转
    open private(set) var isRotating = false
    
    /// 转动结束后指向的item的index
    open private(set) var selectedIndex = 0
    
    private var rotationFromAngle = 0.0
    private var rotationToAngle = 0.0
    
    open private(set) var cellCount: Int = 0 {
        didSet {
            rotationPerAngle = 2 * Double.pi / Double(cellCount)
        }
    }
    open private(set) var center: CGPoint = .zero
    open private(set) var radius: Double = 0
    
    open override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        
        let size = collectionView.frame.size
        cellCount = collectionView.numberOfItems(inSection: 0)
        center = CGPoint(x: size.width / 2, y: size.height / 2)
        radius = min(size.width / 2, size.height / 2) - itemSize.height / 2 - itemOffset
    }
    
    open override var collectionViewContentSize: CGSize {
        return self.collectionView?.frame.size ?? .zero
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.size = itemSize
        //坐标系为：向下y轴正值，向右x轴正值
        let angle = 2.0 * Double.pi * Double(indexPath.item) / Double(cellCount) - Double.pi / 2
        let center = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
        attributes.center = center
        //正值顺时针，负值逆时针
        attributes.transform = CGAffineTransform(rotationAngle: angle + Double.pi / 2)
        return attributes
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for idx in 0..<cellCount {
            let attr = layoutAttributesForItem(at: IndexPath(row: idx, section: 0))!
            attributes.append(attr)
        }
        return attributes
    }
    
    public func rotate() {
        if isRotating {
            return
        }
        rotationFromAngle = rotationToAngle
        
        var randomAngle = Double.random(in: rotationRangeAngle)
        if rotationPerAngle != 0 {
            let count = round(randomAngle / rotationPerAngle)
            randomAngle = rotationPerAngle * count
        }
        rotationToAngle = rotationFromAngle + rotationBaseAngle + randomAngle
        performRotateAnima()
    }
    
    public func rotateTo(index: Int, additionalRoundRange: Range<Int>) {
        if isRotating {
            return
        }
        if index < 0 || index > cellCount {
            return
        }
        rotationFromAngle = rotationToAngle
        
        let fromAngle = rotationFromAngle.truncatingRemainder(dividingBy: 2 * Double.pi)
        var baseAngle = (2 * Double.pi - rotationPerAngle * Double(index)) - fromAngle
        if baseAngle < 0 {
            baseAngle += 2 * Double.pi
        }
        let additionalRound = Int.random(in: additionalRoundRange)
        
        rotationToAngle = rotationFromAngle + baseAngle + Double(additionalRound) * 2 * Double.pi
        performRotateAnima()
    }
    
    public func rotateTo(index: Int) {
        rotateTo(index: index, additionalRoundRange: 0..<1)
    }
    
    public func performRotateAnima() {
        guard let collectionView = self.collectionView else { return }
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = rotationFromAngle
        animation.toValue = rotationToAngle
        animation.duration = rotationTime
        animation.repeatCount = 0
        animation.autoreverses = false
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        collectionView.layer.add(animation, forKey: "rotation")
        
        isRotating = true
        
        if let delegate = collectionView.delegate as? UICollectionViewDelegateCircleLayout {
            delegate.collectionView?(self.collectionView!, layout: self, isBeginRotation: true)
        }
    }
}

extension CircleLayout: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if anim === collectionView?.layer.animation(forKey: "rotation") {
            isRotating = false
            if rotationPerAngle > 0 {
                selectedIndex = cellCount - lround((rotationToAngle.truncatingRemainder(dividingBy: (2 * Double.pi))) / rotationPerAngle)
            }
            if let delegate = collectionView?.delegate as? UICollectionViewDelegateCircleLayout {
                delegate.collectionView?(self.collectionView!, layout: self, isEndRotation: true)
            }
        }
    }
}
