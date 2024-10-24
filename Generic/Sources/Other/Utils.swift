//
//  Utils.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

open class Utils {
    
    static let loadingViewTag = 9000
    
    public static func safeAreaTop() -> CGFloat {
        var num: CGFloat = 0.0
        if #available(iOS 11, *) {
            num = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        } else {
            num = UIApplication.shared.statusBarFrame.size.height
        }
        return num
    }
    
    public static func safeAreaBottom() -> CGFloat {
        var num: CGFloat = 0.0
        if #available(iOS 11, *) {
            num = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            
        }
        return num
    }
    
    public static func navAddTopHeight() -> Double {
        return 44.0 + safeAreaTop()
    }
    
    public static func tabbarAddBottomHeight() -> Double {
        return 49.0 + safeAreaBottom()
    }
    
    public static func showLoading() {
        let blackView = UIView()
        blackView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        blackView.tag = loadingViewTag
        
        let acIndicator = ActivityIndicator(style: .style_0)
        acIndicator.systemIndicatorStype = .white
        acIndicator.starAnimation()
        
        blackView.addSubview(acIndicator)
        
        blackView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        acIndicator.center = CGPoint(x: blackView.frame.width / 2, y: blackView.frame.height / 2)
        
        UIApplication.shared.keyWindow?.addSubview(blackView)
    }
    
    public static func removeLoading() {
        let view = UIApplication.shared.keyWindow?.viewWithTag(loadingViewTag)
        if let view = view {
            view.removeFromSuperview()
        }
    }
    
    public static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    public static func getTopWindow() -> UIWindow? {
        var window: UIWindow?
        for aWindow in UIApplication.shared.windows.reversed() {
            if !aWindow.isHidden && aWindow.bounds == UIScreen.main.bounds {
                window = aWindow
            }
        }
        return window
    }
    
    public static func getMainWindow() -> UIWindow? {
        var window: UIWindow?
        if let appDelegate = UIApplication.shared.delegate {
            window = appDelegate.window ?? nil
        }
        return window
    }
    
    public static func topViewController() -> UIViewController? {
        var vc = UIApplication.shared.keyWindow?.rootViewController
        let topVC = findNextViewControllerFrom(vc: vc)
        return topVC
    }
    
    public static func findNextViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        guard let vc = vc else { return nil }
        var nextVC: UIViewController?
        if vc.presentedViewController != nil {
            nextVC = vc.presentedViewController
            nextVC = findNextViewControllerFrom(vc: nextVC)
        } else if let tc = vc as? UITabBarController {
            nextVC = tc.selectedViewController
            nextVC = findNextViewControllerFrom(vc: nextVC)
        } else if let nc = vc as? UINavigationController {
            nextVC = nc.visibleViewController
            nextVC = findNextViewControllerFrom(vc: nextVC)
        } else {
            nextVC = vc
        }
        return nextVC
    }
}
