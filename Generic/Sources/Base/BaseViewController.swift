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
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBase()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setupBase()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        initialization()
    }

    open func nc() -> NavigationController? {
        let nc = self.navigationController as? NavigationController
        return nc
    }
    
    open func tc() -> TabBarController? {
        let tc = self.tabBarController as? TabBarController
        return tc
    }
    
    open func initialization() {
        setupTopBar()
        setupUI()
        setupOther()
    }
    
    open func setupBase() -> Void {}
    open func setupTopBar() -> Void {}
    open func setupUI() -> Void {}
    open func setupOther() -> Void {}
    
    open func refreshContent() -> Void {}
    open func refreshSizeAndPos() -> Void {}
    open func refresh() -> Void {
        refreshContent()
        refreshSizeAndPos()
    }
}
