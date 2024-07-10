//
//  BaseViewController.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/7.
//

import UIKit

open class BaseViewController: UIViewController {
    
    open lazy var topBar = {
        self.generic.makeNavigationBar(title: "")
    }()
    
    deinit {
        printLog("\(#function): \(type(of: self))")
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
}
