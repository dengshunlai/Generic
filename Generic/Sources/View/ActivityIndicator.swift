//
//  ActivityIndicator.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/1.
//

import UIKit

open class ActivityIndicator: BaseView {
    
    open var style: ActivityIndicatorStyle = .style_0 {
        willSet {
            if newValue != style {
                self.removeAnimation()
            }
        }
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open var systemIndicatorStype = UIActivityIndicatorView.Style.gray
    
    open lazy var systemIndicator = {
        let view = UIActivityIndicatorView(style: systemIndicatorStype)
        return view
    }()
    
    open var indicatorLayer: CALayer?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    public convenience init(style: ActivityIndicatorStyle) {
        self.init(frame: .zero)
        self.style = style
    }
    
    func initialization() {
        
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if style == .style_0 {
            systemIndicator.frame = self.bounds
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        if style == .style_0 {
            return CGSize(width: 30, height: 30)
        } else if style == .style_1 {
            return CGSize(width: 50, height: 50)
        } else if style == .style_2 {
            return CGSize(width: 25, height: 25)
        } else if style == .style_3 {
            return CGSize(width: 25, height: 25)
        } else if style == .style_4 {
            return CGSize(width: 25, height: 25)
        }
        return .zero
    }
    
    public func starAnimation() {
        if style == .style_0 {
            addSubview(systemIndicator)
            systemIndicator.startAnimating()
        } else {
            indicatorLayer?.removeFromSuperlayer()
            indicatorLayer = indicatorLayer(with: style)
            self.layer.addSublayer(indicatorLayer!)
        }
    }
    
    public func removeAnimation() {
        if style == .style_0 {
            systemIndicator.stopAnimating()
        } else {
            indicatorLayer?.removeFromSuperlayer()
        }
    }
    
    public func indicatorLayer(with style: ActivityIndicatorStyle) -> CALayer {
        var layer: CALayer = CALayer()
        if style == .style_1 {
            layer = layerForStyle_1()
        } else if style == .style_2 {
            layer = layerForStyle_2()
        } else if style == .style_3 {
            layer = layerForStyle_3()
        } else if style == .style_4 {
            layer = layerForStyle_4()
        }
        return layer
    }
}

public extension ActivityIndicator {
    
    func layerForStyle_1() -> CALayer {
        let size = 50.0
        let dotSize = 10.0
        
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let redCircleLayer = CALayer()
        redCircleLayer.frame = CGRect(x: 0, y: size / 2 - dotSize / 2, width: dotSize, height: dotSize)
        redCircleLayer.backgroundColor = UIColor.generic.hexColor("FF6347").cgColor
        redCircleLayer.cornerRadius = 5
        redCircleLayer.masksToBounds = true

        let grayCircleLayer = CALayer()
        grayCircleLayer.frame = CGRect(x: size / 2 - dotSize / 2, y: size / 2 - dotSize / 2, width: dotSize, height: dotSize)
        grayCircleLayer.backgroundColor = UIColor.generic.hexColor("E4E4E4").cgColor
        grayCircleLayer.cornerRadius = 5
        grayCircleLayer.masksToBounds = true
        
        let blueCircleLayer = CALayer()
        blueCircleLayer.frame = CGRect(x: size - dotSize, y: size / 2 - dotSize / 2, width: dotSize, height: dotSize)
        blueCircleLayer.backgroundColor = UIColor.generic.hexColor("4876FF").cgColor
        blueCircleLayer.cornerRadius = 5
        blueCircleLayer.masksToBounds = true
        
        layer.addSublayer(redCircleLayer)
        layer.addSublayer(grayCircleLayer)
        layer.addSublayer(blueCircleLayer)
        
        let redAnimation = CABasicAnimation()
        redAnimation.keyPath = "transform"
        redAnimation.fromValue = CATransform3DIdentity
        redAnimation.toValue = CATransform3DMakeTranslation(size - dotSize, 0, 0)
        redAnimation.repeatCount = .infinity
        redAnimation.duration = 1
        redAnimation.autoreverses = true
        redAnimation.isRemovedOnCompletion = false
        redAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let blueAnimation = CABasicAnimation()
        blueAnimation.keyPath = "transform"
        blueAnimation.fromValue = CATransform3DIdentity
        blueAnimation.toValue = CATransform3DMakeTranslation(-size + dotSize, 0, 0)
        blueAnimation.repeatCount = .infinity
        blueAnimation.duration = 1
        blueAnimation.autoreverses = true
        blueAnimation.isRemovedOnCompletion = false
        blueAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        redCircleLayer.add(redAnimation, forKey: "red")
        blueCircleLayer.add(blueAnimation, forKey: "blue")

        return layer
    }
    
    func layerForStyle_2() -> CALayer {
        let size = 25.0
        
        let layer = CAShapeLayer()
        let path = UIBezierPath.init(arcCenter: CGPoint(x: size / 2, y: size / 2),
                                     radius: size / 2 - 1,
                                     startAngle: 0,
                                     endAngle: 1.6 * Double.pi,
                                     clockwise: true)
        path.lineWidth = 2
        layer.path = path.cgPath
        layer.strokeColor = UIColor.generic.hexColor("FF8C00").cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.z"
        animation.fromValue = 0
        animation.toValue = 2 * Double.pi
        animation.duration = 1
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false
        
        layer.add(animation, forKey: "style_2")
        return layer
    }
    
    func layerForStyle_3() -> CALayer {
        let size = 25
        
        let layer = CAShapeLayer()
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size, height: size))
        layer.path = path.cgPath
        layer.fillColor = UIColor.generic.hexColor("BA55D3").cgColor
        layer.frame = CGRect(x: 0, y: 0, width: size, height: size)
        
        let xAnimation = CABasicAnimation()
        xAnimation.keyPath = "transform.rotation.x"
        xAnimation.fromValue = 0
        xAnimation.toValue = Double.pi
        xAnimation.beginTime = 0
        xAnimation.duration = 0.8
        xAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let yAnimation = CABasicAnimation()
        yAnimation.keyPath = "transform.rotation.y"
        yAnimation.fromValue = 0
        yAnimation.toValue = Double.pi
        yAnimation.beginTime = 0.8
        yAnimation.duration = 0.8
        xAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let group = CAAnimationGroup()
        group.animations = [xAnimation, yAnimation]
        group.duration = 1.6
        group.repeatCount = .infinity
        group.isRemovedOnCompletion = false
        
        layer.add(group, forKey: "style_3")
        return layer
    }
    
    func layerForStyle_4() -> CALayer {
        let size = 25.0
        
        let layer = CAShapeLayer()
        let path = UIBezierPath.init(arcCenter: CGPoint(x: size / 2, y: size / 2),
                                     radius: size / 2.0 - 1,
                                     startAngle: 0,
                                     endAngle: 2 * Double.pi,
                                     clockwise: true)
        path.lineWidth = 2
        layer.path = path.cgPath
        layer.strokeColor = UIColor.generic.hexColor("828282").cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.frame = CGRectMake(0, 0, size, size)
        
        let rotationAnimation = CABasicAnimation()
        rotationAnimation.keyPath = "transform.rotation.z"
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * Double.pi
        
        let strokeStartAnimation = CABasicAnimation()
        strokeStartAnimation.keyPath = "strokeStart"
        strokeStartAnimation.fromValue = 0
        strokeStartAnimation.toValue = 1
        strokeStartAnimation.beginTime = 0
        strokeStartAnimation.duration = 0.7
        
        let strokeEndAnimation = CABasicAnimation()
        strokeEndAnimation.keyPath = "strokeEnd"
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1
        strokeEndAnimation.beginTime = 0.7
        strokeEndAnimation.duration = 0.7
        
        let group = CAAnimationGroup()
        group.animations = [rotationAnimation, strokeStartAnimation, strokeEndAnimation]
        group.duration = 1.4
        group.repeatDuration = .infinity
        group.isRemovedOnCompletion = false
        group.timeOffset = 0.5
        
        layer.add(group, forKey: "style_4")
        return layer
    }
}

public enum ActivityIndicatorStyle: Int {
    case style_0 = 0
    case style_1 = 1
    case style_2 = 2
    case style_3 = 3
    case style_4 = 4
}
