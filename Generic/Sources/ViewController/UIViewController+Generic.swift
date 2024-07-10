//
//  UIViewController+Generic.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import UIKit

private var navigationBarKey: Void?

extension UIViewController: GenericNameSpaceProtocol {}

//自定义导航控制器相关
public extension GenericNameSpace where T: UIViewController {
    
    func navigationBar() -> NavigationBar? {
        let bar = objc_getAssociatedObject(obj, &navigationBarKey) as? NavigationBar
        return bar
    }
    
    @discardableResult
    func makeNavigationBar() -> NavigationBar {
        return makeNavigationBar(title: "")
    }
    
    @discardableResult
    func makeNavigationBar(title: String) -> NavigationBar {
        var bar = navigationBar()
        if bar != nil {
            return bar!
        }
        bar = NavigationBar(title: title)
        bar!.vc = obj
        bar!.layer.zPosition = 100
        obj.view.addSubview(bar!)
        bar?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bar!.leadingAnchor.constraint(equalTo: obj.view.leadingAnchor, constant: 0),
            bar!.trailingAnchor.constraint(equalTo: obj.view.trailingAnchor, constant: 0),
            bar!.topAnchor.constraint(equalTo: obj.view.topAnchor, constant: 0),
            bar!.heightAnchor.constraint(equalToConstant: Utils.safeAreaTop() + 44)
        ])
        
        objc_setAssociatedObject(obj, &navigationBarKey, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar!
    }
    
    func navigationController() -> NavigationController? {
        let nc = obj.navigationController as? NavigationController
        return nc
    }
    
    func tabBarController() -> TabBarController? {
        let tc = obj.tabBarController as? TabBarController
        return tc
    }
}

//自定义转场相关
private var presentAnimatorKey: Void?

public extension GenericNameSpace where T: UIViewController {
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent.generic.presentAnimator()?.type != VCInteractiveAnimator.TransitionStyle.none {
            viewControllerToPresent.transitioningDelegate = viewControllerToPresent.generic.presentAnimator()
            viewControllerToPresent.generic.presentAnimator()?.presentSenderViewController = obj
            viewControllerToPresent.modalPresentationStyle = .fullScreen
        } else {
            if viewControllerToPresent.transitioningDelegate is VCInteractiveAnimator {
                viewControllerToPresent.transitioningDelegate = nil
            }
        }
        obj.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func presentAnimator() -> VCInteractiveAnimator? {
        var animator = objc_getAssociatedObject(obj, &presentAnimatorKey) as? VCInteractiveAnimator
        if animator == nil {
            animator = VCInteractiveAnimator()
            animator?.presentViewController = obj
            setPresentAnimator(animator: animator)
        }
        return animator
    }
    
    func setPresentAnimator(animator: VCInteractiveAnimator?) {
        objc_setAssociatedObject(obj, &presentAnimatorKey, animator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}


