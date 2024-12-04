//
//  TabContainerVC.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/22.
//

import UIKit

open class TabContainerVC: BaseViewController {
    
    open lazy private(set) var tc: UITabBarController = {
        let tc = UITabBarController()
        tc.tabBar.isHidden = true
        return tc
    }()
    
    open var containerView: UIView {
        get {
            return tc.view
        }
    }
    
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
    }
    
    open override func setupUI() {
        self.addChild(tc)
        self.view.addSubview(tc.view)
        tc.didMove(toParent: self)
    }
}
