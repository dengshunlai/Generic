//
//  AppDelegate.swift
//  SwiftProj
//
//  Created by 邓顺来1992 on 2024/5/4.
//

import UIKit
import Generic

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        window?.makeKeyAndVisible()
        
        if #available(iOS 11, *) {
            let scrollViewAppearance = UIScrollView.appearance()
            scrollViewAppearance.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 15, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
        
        let nc1 = NavigationController.init(rootViewController: AViewController(), type: 0)
        let nc2 = NavigationController.init(rootViewController: BViewController(), type: 0)
        let nc3 = NavigationController.init(rootViewController: CViewController(), type: 0)
        let nc4 = NavigationController.init(rootViewController: DViewController(), type: 0)
        
        let tc = TabBarController()
        tc.viewControllers = [nc1, nc2, nc3, nc4]
        tc.aTabBar.add(item: TabBarItem.init(text: "首页",
                                                   image: UIImage(named: "Home")!,
                                                   selImage: UIImage(named: "Home_selected")!,
                                                   color: UIColor.generic.hexColor("999999"),
                                                   selColor: UIColor.orange))
        tc.aTabBar.add(item: TabBarItem.init(text: "分类",
                                                   image: UIImage(named: "Categories")!,
                                                   selImage: UIImage(named: "Categories_selected")!,
                                                   color: UIColor.generic.hexColor("999999"),
                                                   selColor: UIColor.orange))
        tc.aTabBar.add(item: TabBarItem.init(text: "购物车",
                                                   image: UIImage(named: "Cart")!,
                                                   selImage: UIImage(named: "Cart_selected")!,
                                                   color: UIColor.generic.hexColor("999999"),
                                                   selColor: UIColor.orange))
        tc.aTabBar.add(item: TabBarItem.init(text: "我的",
                                                   image: UIImage(named: "Account")!,
                                                   selImage: UIImage(named: "Account_selected")!,
                                                   color: UIColor.generic.hexColor("999999"),
                                                   selColor: UIColor.orange))
        
        window?.rootViewController = tc
        
        return true
    }

}

