//
//  LabelItem.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/23.
//

import UIKit
import Generic
import SnapKit

class LabelItem: BaseCollectionViewCell {
    
    var label: UILabel!
    
    override func setupUI() {
        super.setupUI()
        label = {
            let label = UILabel.init()
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 15)
            label.numberOfLines = 1
            label.textAlignment = .left
            return label
        }()
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(15)
            make.centerY.equalToSuperview()
        }
    }
    
    func fillCell(text: String) -> Void {
        label.text = text
    }
}

