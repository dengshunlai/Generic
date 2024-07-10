//
//  BaseTableViewCell.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

open class BaseTableViewCell: UITableViewCell, IdentifierProtocol {
    
    deinit {
        printLog("\(#function): \(type(of: self))")
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBase()
        setupUI()
        setup()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBase()
        setupUI()
        setup()
    }
    
    open func setupBase() -> Void {}
    open func setupUI() -> Void {}
    open func setup() -> Void {}
}



