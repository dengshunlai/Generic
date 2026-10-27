//
//  TextCell.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit
import Generic
import SnapKit

class TextCell: BaseTableViewCell {
    
    lazy var icon: UIImageView = {
        let icon = UIImageView.init()
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    lazy var label: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("666666")
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = kScreenWidth - 10 - 30 - 10 - 10
        return label
    }()
    var textList: [String] = [
        "火火火火火火火火火火火火火火",
        "水水水水水水水水水水水水水水",
        "雷雷雷雷雷雷雷雷雷雷雷雷雷雷",
        "土土土土土土土土土土土土土土",
        "风风风风风风风风风风风风风风",
        "阴阴阴阴阴阴阴阴阴阴阴阴阴阴",
        "阳阳阳阳阳阳阳阳阳阳阳阳阳阳",
    ]
    
    override func setupUI() {
        
        contentView.addSubview(icon)
        contentView.addSubview(label)
        
        icon.snp.makeConstraints { make in
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.leading.equalTo(contentView).offset(10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }
        label.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(10)
            make.trailing.equalTo(contentView).offset(-10)
            make.top.equalTo(contentView).offset(10)
            make.bottom.lessThanOrEqualTo(contentView).offset(-10)
        }
    }
    
    func fillCell(count: Int) -> Void {
        icon.image = UIImage(named: "Account_selected")
        var text: String = ""
        for _ in 1...count {
            let idx = arc4random_uniform(UInt32(textList.count))
            text += textList[Int(idx)]
        }
        label.text = text
    }
}
