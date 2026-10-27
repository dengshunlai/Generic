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
            num = activeWindow()?.safeAreaInsets.top ?? 0
        } else {
            num = UIApplication.shared.statusBarFrame.size.height
        }
        return num
    }
    
    public static func safeAreaBottom() -> CGFloat {
        var num: CGFloat = 0.0
        if #available(iOS 11, *) {
            num = activeWindow()?.safeAreaInsets.bottom ?? 0
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
        
        getKeyWindow()?.addSubview(blackView)
    }
    
    public static func removeLoading() {
        let view = getKeyWindow()?.viewWithTag(loadingViewTag)
        if let view = view {
            view.removeFromSuperview()
        }
    }
    
    public static func activeWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            let activeScene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
            guard let scene = activeScene else { return nil }
            // 1. 优先 normal 层级的正常窗口中的 keyWindow
            let candidateWindows = scene.windows.filter { !$0.isHidden && $0.windowLevel == .normal }
            // 2. 防御性降级：过滤过严时放宽到该场景内任意 keyWindow / 任意 window
            return candidateWindows.first { $0.isKeyWindow }
                ?? candidateWindows.first
                ?? scene.windows.first { $0.isKeyWindow }
                ?? scene.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    public static func getKeyWindow() -> UIWindow? {
        return UIApplication.shared.windows.filter({$0.isKeyWindow}).first
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
        let vc = getKeyWindow()?.rootViewController
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
