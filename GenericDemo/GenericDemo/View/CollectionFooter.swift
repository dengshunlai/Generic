//
//  CollectionFooter.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/24.
//

import UIKit
import Generic

class CollectionFooter: BaseCollectionViewHeaderFooter {
    
    lazy var titleLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("666666")
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override func setupUI() {
        backgroundColor = UIColor.generic.hexColor("efefef")
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}

