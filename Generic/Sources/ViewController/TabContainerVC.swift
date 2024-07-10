//
//  TabContainerVC.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/22.
//

import UIKit

open class TabContainerVC: BaseViewController {
    
    open var tc: UITabBarController!
    open var containerView: UIView!
    open var viewControllers: [UIViewController] = [] {
        didSet {
            tc.viewControllers = viewControllers
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tc = UITabBarController()
        tc.tabBar.isHidden = true
        self.addChild(tc)
        self.view.addSubview(tc.view)
        tc.didMove(toParent: self)
        
        containerView = tc.view
    }
}
