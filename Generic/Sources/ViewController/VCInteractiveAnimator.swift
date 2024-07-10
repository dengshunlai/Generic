//
//  VCInteractiveAnimator.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/17.
//

import UIKit

open class VCInteractiveAnimator: UIPercentDrivenInteractiveTransition {
    
    /// 转场类型
    public var type: TransitionStyle = .none
    
    /// type = 3时有效
    public weak var fromView: UIView?
    
    /// type = 3时有效
    public weak var toView: UIView?
    
    /// type = 4时有效，转场开始时，圆圈的位置、大小
    public var fromRect: CGRect = .zero
    
    /// type = 5、8时有效，视窗大小
    public var size: CGSize = CGSize(width: 280, height: 280)
    
    /// type = 6、9时有效，抽屉伸出的宽度，默认 屏幕宽度-70
    public var width: CGFloat = kScreenWidth - 70
    
    /// type = 1、2、7时有效，抽屉伸出的高度，默认 280
    public var height: CGFloat = 280
    
    /// type = 2、7时有效，默认0.85
    public var scale: CGFloat = 0.85
    
    /// 是否进行交互式转场，暴露这个属性出来用于手动实现交互式present
    public var isInteractive: Bool = false
    
    /// 被present的VC
    internal weak var presentViewController: UIViewController?
    
    /// 发出present的VC
    internal weak var presentSenderViewController: UIViewController?
    
    private var isPresent: Bool = false
    
    public override init() {
        super.init()
    }
}

extension VCInteractiveAnimator: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        isPresent = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        isPresent = false
        return self
    }
    
    public func interactionControllerForPresentation(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        return isInteractive ? self : nil
    }
    
    public func interactionControllerForDismissal(using animator: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        switch type {
        case .type2, .type9:
            return isInteractive ? self : nil
        default:
            return nil
        }
    }
}

extension VCInteractiveAnimator: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        switch type {
        case .type4:
            return 0.55
        case .type5:
            return 0.25
        case .type8:
            return 0.25
        default:
            return 0.35
        }
    }
    
    public func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let containerView = transitionContext.containerView
        
        if type == .type1 {
            if isPresent {
                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                bgView.backgroundColor = .black.withAlphaComponent(0.2)
                bgView.alpha = 0
                bgView.tag = 2001
                toView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: height)
                containerView.addSubview(bgView)
                containerView.addSubview(toView)
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(gestureDismissTap(sender:)))
                bgView.addGestureRecognizer(tap)

                UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                    bgView.alpha = 1
                    toView.frame = CGRect(x: 0, y: kScreenHeight - self.height, width: kScreenWidth, height: self.height)
                } completion: { finished in
                    let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: true) ?? UIView()
                    containerView.insertSubview(fromViewSnapshot, belowSubview: bgView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                let bgView = containerView.viewWithTag(2001)!
                toView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
                containerView.insertSubview(toView, belowSubview: bgView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                    bgView.alpha = 0
                    fromView.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: self.height)
                } completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        } else if type == .type2 {
            if isPresent {
                toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, height)
                toView.layer.cornerRadius = 10
                toView.layer.masksToBounds = true
                containerView.addSubview(toView)
                
                fromView.layer.masksToBounds = true
                let cornerAnimation = CABasicAnimation.init(keyPath: "cornerRadius")
                cornerAnimation.duration = transitionDuration(using: transitionContext)
                cornerAnimation.fillMode = .forwards
                cornerAnimation.isRemovedOnCompletion = false
                cornerAnimation.fromValue = 0
                cornerAnimation.toValue = 10
                fromView.layer.add(cornerAnimation, forKey: "cornerRadius")
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                    fromView.transform = CGAffineTransformScale(fromView.transform, self.scale, self.scale)
                    toView.frame = CGRectMake(0, kScreenHeight - self.height, kScreenWidth, self.height)
                } completion: { finished in
                    let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
                    fromViewSnapshot.tag = 2002
                    fromViewSnapshot.transform = CGAffineTransformScale(fromViewSnapshot.transform, self.scale, self.scale)
                    containerView.insertSubview(fromViewSnapshot, belowSubview: toView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                    let pan = UIPanGestureRecognizer.init(target: self, action: #selector(self.gestureDismissPanY(sender:)))
                    fromViewSnapshot.addGestureRecognizer(pan)
                    fromViewSnapshot.layer.removeAnimation(forKey: "cornerRadius")
                }
            } else {
                let toViewSnapshot = containerView.viewWithTag(2002)
                UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
                    toViewSnapshot?.transform = CGAffineTransformIdentity
                    fromView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.height)
                } completion: { finished in
                    toView.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                    let cornerAnimation = CABasicAnimation.init(keyPath: "cornerRadius")
                    cornerAnimation.duration = 0.2
                    cornerAnimation.fromValue = 10
                    cornerAnimation.toValue = 0
                    toView.layer.add(cornerAnimation, forKey: "cornerRadius")
                }
            }
        } else if type == .type3 {
            if isPresent {
                toView.alpha = 0
                toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                containerView.addSubview(toView)
                
                let fromViewSnapshot = self.fromView!.snapshotView(afterScreenUpdates: false) ?? UIView()
                fromViewSnapshot.frame = self.fromView!.convert(self.fromView!.bounds, to: containerView)
                containerView.addSubview(fromViewSnapshot)
                self.fromView?.isHidden = true
                self.toView?.isHidden = true
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    fromViewSnapshot.frame = self.toView!.convert(self.toView!.bounds, to: containerView)
                    toView.alpha = 1
                } completion: { finished in
                    self.toView?.isHidden = false
                    fromViewSnapshot.isHidden = true
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                containerView.insertSubview(toView, belowSubview: fromView)
                let fromViewSnapshot = containerView.subviews.last
                fromViewSnapshot?.isHidden = false
                self.toView?.isHidden = true

                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    fromViewSnapshot?.frame = self.fromView!.convert(self.fromView!.bounds, to: containerView)
                    fromView.alpha = 0
                } completion: { finished in
                    self.fromView?.isHidden = false
                    fromViewSnapshot?.isHidden = true
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        } else if type == .type4 {
            if (isPresent) {
                toView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                containerView.addSubview(toView)
                if CGRectIsEmpty(fromRect) {
                    fromRect = CGRectMake(CGRectGetWidth(toView.bounds) / 2 - 10,
                                          CGRectGetHeight(toView.bounds) / 2 - 10,
                                          20, 20);
                }
                var radius = min(fromRect.size.width, fromRect.size.height)
                let center = CGPointMake(fromRect.origin.x + fromRect.size.width / 2, fromRect.origin.y + fromRect.size.height / 2)
                let startPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * Double.pi, clockwise: true)
                radius = sqrt(pow(toView.bounds.size.width / 2, 2) + pow(toView.bounds.size.height / 2, 2))
                let endPath = UIBezierPath.init(arcCenter: toView.center, radius: radius, startAngle: 0, endAngle: 2 * Double.pi, clockwise: true)
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = startPath.cgPath
                toView.layer.mask = maskLayer
                
                let animation = CABasicAnimation(keyPath: "path")
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                animation.fromValue = startPath.cgPath
                animation.toValue = endPath.cgPath
                animation.duration = transitionDuration(using: transitionContext)
                animation.delegate = self
                animation.setValue(transitionContext, forKey: "transitionContext")
                maskLayer.add(animation, forKey: "path")
            } else {
                containerView.insertSubview(toView, belowSubview: fromView)
                var radius = sqrt(pow(fromView.bounds.size.width / 2, 2) + pow(fromView.bounds.size.height / 2, 2))
                let startPath = UIBezierPath.init(arcCenter: fromView.center, radius: radius, startAngle: 0, endAngle: 2 * Double.pi, clockwise: true)
                radius = min(fromRect.size.width, fromRect.size.height)
                let center = CGPointMake(fromRect.origin.x + fromRect.size.width / 2, fromRect.origin.y + fromRect.size.height / 2)
                let endPath = UIBezierPath.init(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * Double.pi, clockwise: true)
                
                let maskLayer = CAShapeLayer()
                maskLayer.path = startPath.cgPath
                fromView.layer.mask = maskLayer
                
                let animation = CABasicAnimation.init(keyPath: "path")
                animation.isRemovedOnCompletion = false
                animation.fillMode = .forwards
                animation.fromValue = startPath.cgPath
                animation.toValue = endPath.cgPath
                animation.duration = transitionDuration(using: transitionContext)
                animation.delegate = self
                animation.setValue(transitionContext, forKey: "transitionContext")
                maskLayer.add(animation, forKey: "path")
            }
        } else if type == .type5 {
            if (isPresent) {
                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                bgView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                bgView.alpha = 0
                bgView.tag = 2005
                containerView.addSubview(bgView)
                
                toView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
                toView.center = containerView.center
                toView.alpha = 0
                containerView.addSubview(toView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0) {
                    toView.alpha = 1
                    bgView.alpha = 1
                } completion: { finished in
                    let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
                    containerView.insertSubview(fromViewSnapshot, belowSubview: bgView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                    let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.gestureDismissTap(sender:)))
                    bgView.addGestureRecognizer(tap)
                }
            } else {
                let bgView = containerView.viewWithTag(2005)!
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveLinear]) {
                    bgView.alpha = 0
                    fromView.alpha = 0
                } completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        } else if type == .type6 {
            if (isPresent) {
                toView.frame = CGRectMake(-width, 0, width, kScreenHeight)
                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                bgView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                bgView.alpha = 0
                bgView.tag = 2006
                containerView.addSubview(bgView)
                containerView.addSubview(toView)
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(gestureDismissTap(sender:)))
                bgView.addGestureRecognizer(tap)

                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    bgView.alpha = 1
                    toView.frame = CGRectMake(0, 0, self.width, kScreenHeight)
                } completion: { finished in
                    let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
                    fromViewSnapshot.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                    containerView.insertSubview(fromViewSnapshot, belowSubview: bgView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                let bgView = containerView.viewWithTag(2006)!
                containerView.insertSubview(toView, belowSubview: bgView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    bgView.alpha = 0
                    fromView.frame = CGRectMake(-self.width, 0, self.width, kScreenHeight)
                } completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        } else if type == .type7 {
            if (isPresent) {
                toView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, height);
                containerView.addSubview(toView)
                
                let bg = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                bg.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                containerView.insertSubview(bg, belowSubview: toView)
                bg.tag = 20071
                bg.alpha = 0
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    fromView.transform = CGAffineTransformScale(fromView.transform, self.scale, self.scale)
                    toView.frame = CGRectMake(0, kScreenHeight - self.height, kScreenWidth, self.height);
                    bg.alpha = 1;
                } completion: { finished in
                    let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
                    fromViewSnapshot.tag = 20072
                    fromViewSnapshot.transform = CGAffineTransformScale(fromViewSnapshot.transform, self.scale, self.scale)
                    containerView.insertSubview(fromViewSnapshot, belowSubview: bg)
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    
                    let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.gestureDismissTap(sender:)))
                    bg.addGestureRecognizer(tap)
                }
            } else {
                let toViewSnapshot = containerView.viewWithTag(20072)!
                let bg = containerView.viewWithTag(20071)!
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    toViewSnapshot.transform = CGAffineTransformIdentity
                    fromView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, self.height)
                    bg.alpha = 0
                } completion: { finished in
                    toView.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        } else if type == .type8 {
            if (isPresent) {
                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                bgView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                bgView.alpha = 0
                bgView.tag = 2008
                containerView.addSubview(bgView)
                
                toView.frame = CGRectMake(0, 0, size.width, size.height)
                toView.center = containerView.center
                toView.alpha = 0
                containerView.addSubview(toView)
                
                UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear]) {
                    toView.transform = CGAffineTransformScale(toView.transform, 1.2, 1.2)
                    bgView.alpha = 1
                    toView.alpha = 1
                } completion: { finished in
                    UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn]) {
                        toView.transform = CGAffineTransformIdentity
                    } completion: { finished in
                        let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
                        containerView.insertSubview(fromViewSnapshot, belowSubview: bgView)
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        
                        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.gestureDismissTap(sender:)))
                        bgView.addGestureRecognizer(tap)
                    }
                }
            } else {
                let bgView = containerView.viewWithTag(2008)!
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear]) {
                    fromView.transform = CGAffineTransformScale(fromView.transform, 1.3, 1.3)
                } completion: { finished in
                    UIView.animate(withDuration: 0.15, delay: 0, options: [.curveLinear]) {
                        bgView.alpha = 0
                        fromView.transform = CGAffineTransformScale(fromView.transform, 0.05, 0.05)
                    } completion: { finished in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    }
                }
            }
        } else if type == .type9 {
            if (isPresent) {
                toView.frame = CGRectMake(-width, 0, width, kScreenHeight)
                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                bgView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                bgView.alpha = 0
                bgView.tag = 2009
                containerView.addSubview(bgView)
                containerView.addSubview(toView)
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(gestureDismissTap(sender:)))
                bgView.addGestureRecognizer(tap)

                let pan = UIPanGestureRecognizer.init(target: self, action: #selector(gestureDismissPanX(sender:)))
                toView.addGestureRecognizer(pan)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    bgView.alpha = 1
                    toView.frame = CGRectMake(0, 0, self.width, kScreenHeight)
                } completion: { finished in
                    let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
                    fromViewSnapshot.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                    containerView.insertSubview(fromViewSnapshot, belowSubview: bgView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                let bgView = containerView.viewWithTag(2009)!
                containerView.insertSubview(toView, belowSubview: bgView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    bgView.alpha = 0
                    fromView.frame = CGRectMake(-self.width, 0, self.width, kScreenHeight)
                } completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        } else if type == .type10 {
            if (isPresent) {
                toView.frame = CGRectMake(kScreenWidth, 0, width, kScreenHeight)
                let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
                bgView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                bgView.alpha = 0
                bgView.tag = 2006
                containerView.addSubview(bgView)
                containerView.addSubview(toView)
                
                let tap = UITapGestureRecognizer.init(target: self, action: #selector(gestureDismissTap(sender:)))
                bgView.addGestureRecognizer(tap)

                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    bgView.alpha = 1
                    toView.frame = CGRectMake(kScreenWidth - self.width, 0, self.width, kScreenHeight)
                } completion: { finished in
                    let fromViewSnapshot = fromView.snapshotView(afterScreenUpdates: false) ?? UIView()
                    fromViewSnapshot.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                    containerView.insertSubview(fromViewSnapshot, belowSubview: bgView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                let bgView = containerView.viewWithTag(2006)!
                containerView.insertSubview(toView, belowSubview: bgView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: [.curveEaseOut]) {
                    bgView.alpha = 0
                    fromView.frame = CGRectMake(kScreenWidth, 0, self.width, kScreenHeight)
                } completion: { finished in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        }
    }
}

extension VCInteractiveAnimator: CAAnimationDelegate {
    @objc func gestureDismissTap(sender: UITapGestureRecognizer) {
        presentViewController?.dismiss(animated: true)
    }
    
    @objc func gestureDismissPanY(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            isInteractive = true
            presentViewController?.dismiss(animated: true)
        case .changed:
            let translation = sender.translation(in: sender.view)
            let percent = translation.y / 150.0
            if percent >= 1 {
                self.finish()
            } else {
                self.update(percent)
            }
        case .ended, .cancelled, .failed:
            let translation = sender.translation(in: sender.view)
            let percent = translation.y / 150.0
            if percent > 0.5 {
                self.finish()
            } else {
                self.cancel()
            }
            isInteractive = false
        default:
            break
        }
    }
    
    @objc func gestureDismissPanX(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            isInteractive = true
            presentViewController?.dismiss(animated: true)
        case .changed:
            let translation = sender.translation(in: sender.view)
            let percent = -translation.x / width
            if percent >= 1 {
                self.finish()
            } else {
                self.update(percent)
            }
        case .ended, .cancelled, .failed:
            let translation = sender.translation(in: sender.view)
            let percent = -translation.x / width
            if percent > 0.3 {
                self.finish()
            } else {
                self.cancel()
            }
            isInteractive = false
        default:
            break
        }
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let transitionContext = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)
        if isPresent {
            toView?.layer.mask?.removeAllAnimations()
            toView?.layer.mask = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        } else {
            fromView?.layer.mask?.removeAllAnimations()
            fromView?.layer.mask = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}

public extension VCInteractiveAnimator {
    
     enum TransitionStyle: Int {
         case none = 0
         case type1  //BottomTranslationTap
         case type2  //BottomTranslationPan
         case type3  //FromTo
         case type4  //CircularEnlarge
         case type5  //CenterGradient
         case type6  //LeftTransitionTap
         case type7  //BottomTranslationScaleTap
         case type8  //CenterSpring
         case type9  //LeftTranslutionPan
         case type10 //RightTransitionTap
        //定义你自己的type
    }
}

func test() -> Void {
    let _ = VCInteractiveAnimator.TransitionStyle.type9
}
