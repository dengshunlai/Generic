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
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
}
