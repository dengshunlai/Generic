//
//  ImgCell.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/25.
//

import UIKit
import Generic

class ImgCell: BaseCollectionViewCell {
    
    lazy var iv = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override func setupUI() {
        super.setupUI()
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.addSubview(iv)
        bottomLine.isHidden = true
        
        iv.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    func fillCell(imgName: String) {
        iv.image = UIImage(named: imgName)
    }
}
