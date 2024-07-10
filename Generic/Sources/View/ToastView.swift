//
//  ToastView.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/1.
//

import UIKit

open class ToastView: BaseView, CAAnimationDelegate {
    
    public static let sharedInstance = ToastView()
    
    open var option: ToastViewOption = ToastViewOption()
    
    open var isToastStaying: Bool = false
    
    open var text: String? {
        didSet {
            label!.text = text
        }
    }
    
    open var label: UILabel!
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    func initialization() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.layer.cornerRadius = option.cornerRadius
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = false
        
        label = {
            let label = UILabel.init()
            label.textColor = option.textColor
            label.font = option.font
            label.numberOfLines = 0
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    public static func showText(text: String,
                                delay: Double = 0,
                                position: ToastViewPositionType = .center,
                                yOffset: Double = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            let attrStr = NSMutableAttributedString(string: text)
            
            let paragStyle = NSMutableParagraphStyle()
            paragStyle.lineSpacing = sharedInstance.option.lineSpacing
            paragStyle.alignment = .center
            
            attrStr.addAttributes([.foregroundColor: sharedInstance.option.textColor,
                                   .font: sharedInstance.option.font,
                                   .paragraphStyle: paragStyle],
                                  range: NSRange(location: 0, length: attrStr.length))
            
            sharedInstance.label.attributedText = attrStr
            
            sharedInstance.label.preferredMaxLayoutWidth = kScreenWidth - sharedInstance.option.widthPadding - sharedInstance.option.edge * 2
            let toastWidth = sharedInstance.label.intrinsicContentSize.width + sharedInstance.option.widthPadding
            let toastHeight = sharedInstance.label.intrinsicContentSize.height + sharedInstance.option.heightPadding
            sharedInstance.frame = CGRect(x: 0, y: 0, width: toastWidth, height: toastHeight)
            
            var center = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2)
            if position == .center {
                center.y += yOffset
            } else if position == .bottom {
                center.y = kScreenHeight - toastHeight / 2 - Utils.safeAreaBottom() - sharedInstance.option.bottomSpace
            } else if position == .top {
                center.y = toastHeight / 2 + Utils.safeAreaTop() + sharedInstance.option.topSpace
            }
            sharedInstance.center = center
            
            Utils.getMainWindow()?.addSubview(sharedInstance)
            
            NSObject.cancelPreviousPerformRequests(withTarget: sharedInstance, selector: #selector(sharedInstance.dismissToast), object: nil)
            sharedInstance.layer.removeAnimation(forKey: "dismiss")
            sharedInstance.layer.removeAnimation(forKey: "appear")
            
            if sharedInstance.isToastStaying {
                sharedInstance.perform(#selector(sharedInstance.dismissToast),
                                       with: nil,
                                       afterDelay: sharedInstance.option.stayTime,
                                       inModes: [.common])
            } else {
                sharedInstance.appearToast()
            }
        }
    }
    
    func appearToast() {
        let appear = CABasicAnimation(keyPath: "opacity")
        appear.fromValue = 0
        appear.toValue = 1
        appear.duration = option.fadeStartAnimationDuration
        appear.isRemovedOnCompletion = false
        appear.fillMode = .forwards
        appear.delegate = self
        self.layer.add(appear, forKey: "appear")
    }
    
    @objc func dismissToast() {
        self.isToastStaying = false
        
        let dismiss = CABasicAnimation(keyPath: "opacity")
        dismiss.fromValue = 1
        dismiss.toValue = 0
        dismiss.duration = option.fadeDismissAnimationDuration
        dismiss.isRemovedOnCompletion = false
        dismiss.fillMode = .forwards
        dismiss.delegate = self
        self.layer.add(dismiss, forKey: "dismiss")
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if self.layer.animation(forKey: "appear") === anim {
            self.layer.removeAnimation(forKey: "appear")
            let stayTime = option.stayTime
            self.perform(#selector(dismissToast), with: nil, afterDelay: stayTime, inModes: [.common])
            self.isToastStaying = true
        } else if self.layer.animation(forKey: "dismiss") === anim {
            self.layer.removeAnimation(forKey: "dismiss")
            self.removeFromSuperview()
        }
    }
}


open class ToastViewOption: NSObject {
    
    /// 位置类型，默认显示在中间
    open var positionType: ToastViewPositionType = .center
    
    /// 字体
    open var font = UIFont.systemFont(ofSize: 17)
    
    /// 字体颜色
    open var textColor = UIColor.white
    
    /// 行间距
    open var lineSpacing = 3.0
    
    /// 宽的填充
    open var widthPadding = 50.0
    
    /// 高的填充
    open var heightPadding = 20.0
    
    /// 两边距离屏幕最小间距
    open var edge = 10.0
    
    /// 渐显动画的时间长度，默认0.2
    open var fadeStartAnimationDuration = 0.2
    
    /// 渐灭动画的时间长度，默认0.3
    open var fadeDismissAnimationDuration = 0.2
    
    /// toast停留显示的时间长度，默认1.5，上述三个时间之和为toast的整个显示时长
    open var stayTime = 1.5
    
    /// 距离底部的间距，positionType = .bottom 时有效
    open var bottomSpace = 49.0 + 10.0
    
    /// 距离顶部的间距，positionType = .top 时有效
    open var topSpace = 44.0 + 10.0
    
    /// 圆角
    open var cornerRadius = 10.0
}


public enum ToastViewPositionType: Int {
    case center = 0
    case bottom = 1
    case top = 2
}
