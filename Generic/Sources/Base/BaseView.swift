//
//  BaseView.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/26.
//

import UIKit

open class BaseView: UIView {
    
    deinit {
        DBLog("\(#function): \(type(of: self))")
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    open func initialization() {
        setupBase()
        setupUI()
    }
    
    open func setupBase() {}
    open func setupUI() {}
    
    open func refreshContent() {}
    open func refreshSizeAndPos() {}
    open func refresh() {
        refreshContent()
        refreshSizeAndPos()
    }
}
