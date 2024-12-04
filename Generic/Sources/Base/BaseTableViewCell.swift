//
//  BaseTableViewCell.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

open class BaseTableViewCell: UITableViewCell, IdentifierProtocol {
    
    deinit {
        DBLog("\(#function): \(type(of: self))")
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialization()
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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



