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
        setupBase()
        setupUI()
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupBase()
        setupUI()
        setup()
    }
    
    open func setupBase() -> Void {}
    open func setupUI() -> Void {}
    open func setup() -> Void {}
}
