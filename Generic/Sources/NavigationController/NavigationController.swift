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
    public var edgePan: UIScreenEdgePanGestureRecognizer!
    
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
        view.addGestureRecognizer(edgePan)
    }
    
    @objc func panPop(sender: UIScreenEdgePanGestureRecognizer) -> Void {
        switch sender.state {
        case .began:
            if viewControllers.count <= 1 {
                break
            }
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
            if percent > 0.45 {
                animator.completionSpeed = 1
                animator.finish()
            } else {
                animator.completionSpeed = 0.5
                animator.cancel()
            }
            animator.isInteractive = false
        default:
            break
        }
    }
}
