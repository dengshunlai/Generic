//
//  TextCell3.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/8.
//

import UIKit
import Generic

class TextCell3: BaseCollectionViewCell {
    
    var leftIcon: UIImageView!
    var rightIcon: UIImageView!
    var bottomIcon: UIImageView!
    var label: UILabel!
    var textList: [String] = [
        "火火火火火火火火火火火火火火",
        "水水水水水水水水水水水水水水",
        "雷雷雷雷雷雷雷雷雷雷雷雷雷雷",
        "土土土土土土土土土土土土土土",
        "风风风风风风风风风风风风风风",
        "阴阴阴阴阴阴阴阴阴阴阴阴阴阴",
        "阳阳阳阳阳阳阳阳阳阳阳阳阳阳",
    ]
    
    var tebleview: UITableView?
    
    override func setupUI() {
        super.setupUI()
        leftIcon = UIImageView.init()
        leftIcon.contentMode = .scaleAspectFit
        contentView.addSubview(leftIcon)
        
        rightIcon = UIImageView.init()
        rightIcon.contentMode = .scaleAspectFit
        contentView.addSubview(rightIcon)
        
        bottomIcon = UIImageView.init()
        bottomIcon.contentMode = .scaleAspectFit
        contentView.addSubview(bottomIcon)
        
        label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("666666")
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = kScreenWidth - 10 - 30 - 10 - 30 - 10 - 10
        label.textAlignment = .left
        contentView.addSubview(label)
        
        leftIcon.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.leading.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }
        rightIcon.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.width.equalTo(30)
            make.trailing.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(leftIcon.snp.trailing).offset(10)
            make.trailing.lessThanOrEqualTo(rightIcon.snp.leading).offset(-10)
            make.top.equalTo(contentView).offset(10)
        }
        bottomIcon.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.leading.equalTo(label)
            make.top.equalTo(label.snp.bottom).offset(5)
            make.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let size = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var frame = layoutAttributes.frame
        frame.size.width = kScreenWidth
        frame.size.height = size.height
        layoutAttributes.frame = frame
        return layoutAttributes
    }
    
    func fillCell(count: Int) -> Void {
        leftIcon.image = UIImage(named: "Account_selected")
        rightIcon.image = UIImage(named: "Home_selected")
        bottomIcon.image = UIImage(named: "Categories_selected")
        var text: String = ""
        for _ in 1...count {
            let idx = arc4random_uniform(UInt32(textList.count))
            text += textList[Int(idx)]
        }
        label.text = text
    }
}
