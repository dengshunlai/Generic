//
//  WaterfallCell.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/23.
//

import UIKit
import Generic

class WaterfallCell: BaseCollectionViewCell {
    
    static var picNameList: [String] = ["icon_1","icon_2","icon_3","icon_4","icon_5","icon_6","icon_7","icon_8","icon_9","icon_10"]
    static var textList: [String] = ["天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗",
                                     "天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗天气晴朗",]
    static var subTextList: [String] = ["剑与魔法剑与魔法剑",
                                        "剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法",
                                        "剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法",
                                        "剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法",
                                        "剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法剑与魔法"]
    
    lazy var picIV = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    lazy var textLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("333333")
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.preferredMaxLayoutWidth = (kScreenWidth - 20 - 10) / 2 - 20
        return label
    }()
    lazy var subTextLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("999999")
        label.font = UIFont.systemFont(ofSize: 11)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.preferredMaxLayoutWidth = (kScreenWidth - 20 - 10) / 2 - 20
        return label
    }()
    
    override func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        bottomLine.isHidden = true
        
        contentView.addSubview(picIV)
        contentView.addSubview(textLabel)
        contentView.addSubview(subTextLabel)
        
        picIV.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
        }
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(picIV.snp.bottom).offset(10)
        }
        subTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            make.bottom.equalTo(-10)
        }
    }
    
    func fillCell(index: Int) {
        let image = UIImage(named: Self.picNameList[index % Self.picNameList.count])
        if let image = image {
            picIV.image = image
            picIV.snp.remakeConstraints { make in
                make.top.equalTo(10)
                make.leading.equalTo(10)
                make.trailing.equalTo(-10)
                let width = (kScreenWidth - 20 - 10) / 2 - 20
                make.height.equalTo(width / image.size.width * image.size.height)
            }
        }
        
        textLabel.text = Self.textList[index % Self.textList.count]
        subTextLabel.text = Self.subTextList[index % Self.subTextList.count]
    }
}
