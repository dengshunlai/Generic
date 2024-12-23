//
//  BaseCollectionViewHeaderFooter.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/26.
//

import UIKit

open class BaseCollectionViewHeaderFooter: UICollectionReusableView, IdentifierProtocol {

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
        setupOther()
    }
    
    open func setupBase() {}
    open func setupUI() {}
    open func setupOther() {}
    
    open func refreshContent() {}
    open func refreshSizeAndPos() {}
    open func refresh() {
        refreshContent()
        refreshSizeAndPos()
    }
}
