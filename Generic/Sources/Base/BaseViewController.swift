//
//  BaseViewController.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/7.
//

import UIKit

open class BaseViewController: UIViewController {
    
    /// 手势导致pop的回调，返回true表示正常pop，返回false表示取消pop
    open var gesturePopCallback: (() -> Bool)?
    
    open lazy var topBar = {
        self.generic.makeNavigationBar(title: "")
    }()
    
    deinit {
        DBLog("\(#function): \(type(of: self))")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupBase()
        setupUI()
        setup()
    }
    
    open func setupBase() -> Void {}
    open func setupUI() -> Void {}
    open func setup() -> Void {}
    
    open func nc() -> NavigationController? {
        let nc = self.navigationController as? NavigationController
        return nc
    }
    
    open func tc() -> TabBarController? {
        let tc = self.tabBarController as? TabBarController
        return tc
    }
}
