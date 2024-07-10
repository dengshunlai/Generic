//
//  TableHeaderView.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/26.
//

import UIKit
import Generic

class TableHeaderView: BaseTableViewHeaderFooter {
    
    lazy var label = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = "取消段头停留"
        return label
    }()
    
    override func setupUI() {
        super.setupUI()
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalTo(contentView)
        }
    }
}
