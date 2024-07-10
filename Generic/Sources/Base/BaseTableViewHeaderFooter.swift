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
        setupBase()
        setupUI()
        setup()
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupBase()
        setupUI()
        setup()
    }
    
    open func setupBase() -> Void {}
    open func setupUI() -> Void {}
    open func setup() -> Void {}
}
