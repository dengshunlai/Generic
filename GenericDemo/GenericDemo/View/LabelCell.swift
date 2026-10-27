//
//  LabelCell.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/22.
//

import UIKit
import Generic
import SnapKit

class LabelCell: BaseTableViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    override func setupUI() {
        accessoryType = .disclosureIndicator
        
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

