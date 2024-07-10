//
//  CollectionHeader.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/24.
//

import UIKit
import Generic

class CollectionHeader: BaseCollectionViewHeaderFooter {
    
    lazy var titleLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("333333")
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override func setupUI() {
        backgroundColor = UIColor.generic.hexColor("e4e4e4")
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(12)
        }
    }
}
