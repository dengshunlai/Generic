//
//  BaseTableViewHeaderFooter.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/26.
//

import UIKit

open class BaseTableViewHeaderFooter: UITableViewHeaderFooterView, IdentifierProtocol {
    
    open weak var tableView: UITableView?
    open var section: Int?
    
    public override var frame: CGRect {
        didSet {
            //用于取消段头停留
            if let tableView = tableView, let section = section {
                let rect = tableView.rectForHeader(inSection: section)
                //注意防止无限递归
                if !CGRectEqualToRect(frame, rect) {
                    frame = rect
                }
            }
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
