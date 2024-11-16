//
//  NavigationController.swift
//  SwiftProj
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import UIKit

open class NavigationController: UINavigationController {
    open var type = 0
    var animator: NCInteractiveAnimator!
    var edgePan: UIScreenEdgePanGestureRecognizer!
    var popingViewController: UIViewController?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialization()
    }
    
    public init(rootViewController: UIViewController, type: Int) {
        super.init(rootViewController: rootViewController)
        self.initialization()
    }
    
    func initialization() {
        animator = NCInteractiveAnimator.init(nc: self)
        self.isNavigationBarHidden = true
        self.interactivePopGestureRecognizer?.isEnabled = false
        self.delegate = animator
        
        edgePan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(panPop(sender:)))
        edgePan.edges = .left
        edgePan.delegate = self
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func panPop(sender: UIScreenEdgePanGestureRecognizer) -> Void {
        switch sender.state {
        case .began:
            if viewControllers.count <= 1 {
                break
            }
            popingViewController = topViewController
            animator.isInteractive = true
            popViewController(animated: true)
        case .changed:
            if !animator.isInteractive {
                break
            }
            let point = sender.translation(in: view)
            let percent = point.x / kScreenWidth
            animator.update(percent)
        case .ended, .cancelled, .failed:
            if !animator.isInteractive {
                break
            }
            let point = sender.translation(in: view)
            let percent = point.x / kScreenWidth
            if percent > 0.35 {
                if let gesturePopCallback = (popingViewController as? BaseViewController)?.gesturePopCallback {
                    let b = gesturePopCallback()
                    if b {
                        animator.completionSpeed = 1
                        animator.finish()
                    } else {
                        animator.completionSpeed = 0.5
                        animator.cancel()
                    }
                } else {
                    animator.completionSpeed = 1
                    animator.finish()
                }
            } else {
                let speed = sender.velocity(in: view)
                if speed.x >= 800 {
                    if let gesturePopCallback = (popingViewController as? BaseViewController)?.gesturePopCallback {
                        let b = gesturePopCallback()
                        if b {
                            animator.completionSpeed = 1
                            animator.finish()
                        } else {
                            animator.completionSpeed = 0.5
                            animator.cancel()
                        }
                    } else {
                        animator.completionSpeed = 1
                        animator.finish()
                    }
                } else {
                    animator.completionSpeed = 0.5
                    animator.cancel()
                }
            }
            animator.isInteractive = false
            popingViewController = nil
        default:
            break
        }
    }
}

extension NavigationController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
