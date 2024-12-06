//
//  DSLInteractiveAnimator.swift
//  SwiftProj
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import UIKit

class NCInteractiveAnimator: UIPercentDrivenInteractiveTransition {
    var isPush = false
    var isInteractive = false
    weak var nc: NavigationController?
    
    init(nc: NavigationController) {
        super.init()
        self.nc = nc
    }
}

extension NCInteractiveAnimator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
        switch operation {
        case .push:
            isPush = true
        case .pop:
            isPush = false
        default:
            break
        }
        return self
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: any UIViewControllerAnimatedTransitioning) -> (any UIViewControllerInteractiveTransitioning)? {
        return isInteractive ? self : nil
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let root = navigationController.viewControllers.first
        let tabBarTC = navigationController.generic.tabBarController()
        if let tc = tabBarTC {
            if viewController !== root {
                tc.aTabBar.removeFromSuperview()
                root?.view.addSubview(tc.aTabBar)
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        let root = navigationController.viewControllers.first
        let tabBarTC = navigationController.generic.tabBarController()
        if let tc = tabBarTC {
            if viewController === root {
                tc.aTabBar.removeFromSuperview()
                tc.view.addSubview(tc.aTabBar)
            }
        }
    }
}

extension NCInteractiveAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: (any UIViewControllerContextTransitioning)?) -> TimeInterval {
        if nc?.type == 0 {
            return 0.35
        }
        return 0.35
    }
    
    func animateTransition(using transitionContext: any UIViewControllerContextTransitioning) {
        let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        let contentView = transitionContext.containerView
        
        if nc?.type == 0 {
            //type = 0, 模拟跟系统转场类似
            if isPush {
                toView.frame = CGRect.init(x: kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight)
                toView.layer.shadowOpacity = 0.5
                toView.layer.shadowOffset = CGSize.init(width: -5, height: 5)
                toView.layer.shadowColor = UIColor.lightGray.cgColor
                toView.layer.shadowPath = UIBezierPath.init(rect: toView.bounds).cgPath
                contentView.addSubview(toView)
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
                    fromView.frame = CGRect.init(x: -kScreenWidth / 4, y: 0, width: kScreenWidth, height: kScreenHeight)
                    toView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
                } completion: { finish in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            } else {
                toView.frame = CGRect.init(x: -kScreenWidth / 4, y: 0, width: kScreenWidth, height: kScreenHeight)
                contentView.insertSubview(toView, belowSubview: fromView)
                fromView.layer.shadowOpacity = 0.5
                fromView.layer.shadowOffset = CGSize.init(width: -5, height: 5)
                fromView.layer.shadowColor = UIColor.lightGray.cgColor
                fromView.layer.shadowPath = UIBezierPath.init(rect: toView.bounds).cgPath
                
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveEaseInOut) {
                    toView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
                    fromView.frame = CGRect.init(x: kScreenWidth, y: 0, width: kScreenWidth, height: kScreenHeight)
                } completion: { finish in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                }
            }
        }
    }
}
