//
//  BaseCollectionViewCell.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/7.
//

import UIKit

open class BaseCollectionViewCell: UICollectionViewCell, IdentifierProtocol {
    
    open var bottomLine: UIView!
    
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
        setupOther()
    }
    
    open func setupBase() -> Void {}
    open func setupUI() -> Void {
        bottomLine = UIView.init()
        bottomLine.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bottomLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
    open func setupOther() {}
    
    open func refreshContent() -> Void {}
    open func refreshSizeAndPos() -> Void {}
    open func refresh() -> Void {
        refreshContent()
        refreshSizeAndPos()
    }
}
