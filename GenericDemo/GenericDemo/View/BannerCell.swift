//
//  PlaceholdCell.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/24.
//

import UIKit
import Generic

class BannerCell: BaseCollectionViewCell {
    
    lazy var iv = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.addSubview(iv)
        bottomLine.isHidden = true
        
        iv.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func fillCell(idx: Int) {
        iv.image = UIImage(named: "banner\(idx + 1).jpg")
    }
}
