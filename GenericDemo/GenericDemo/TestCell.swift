//
//  TestCell.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/1.
//

import UIKit
import Generic
import Kingfisher

class TestCell: BaseCollectionViewCell {
    
    var didGetImageSizeBlock: ((Double) -> Void)?
    
    lazy var titleLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.preferredMaxLayoutWidth = kScreenWidth - 24
        return label
    }()
    
    lazy var titleTagIV = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.addSubview(titleTagIV)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(12)
            make.bottom.lessThanOrEqualTo(-12)
        }
    }
    
    override func setup() {
        
    }
    
    func fillCell(tagLink: String, titleTagWidth: Double) {
        let titleAttrStr = NSMutableAttributedString(string: "甲乙丙丁甲乙丙丁甲乙丙丁甲乙丙丁甲乙丙丁测试测试测试测试测试测试测试测试测")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 27
        paragraphStyle.minimumLineHeight = 27
        paragraphStyle.lineSpacing = 0
        if !titleTagIV.isHidden {
            paragraphStyle.firstLineHeadIndent = titleTagWidth + 4
        }
        
        let font = UIFont.systemFont(ofSize: 15)
        let baselineOffset = (paragraphStyle.maximumLineHeight - font.lineHeight) / 4

        titleAttrStr.setAttributes([.font: font,
                                    .foregroundColor: UIColor.generic.hexColor("333333"),
                                    .paragraphStyle: paragraphStyle,
                                    .baselineOffset: baselineOffset],
                                   range: NSRange(location: 0, length: titleAttrStr.length))

        titleLabel.attributedText = titleAttrStr
        
        let placeholder = UIImage(named: "placeholder", in: Bundle(for: Self.self), compatibleWith: nil)
        titleTagIV.kf.setImage(with: URL(string: tagLink), placeholder: placeholder) { [weak self] result in
            switch result {
            case .success(let value):
                let width = value.image.size.width * 14 / value.image.size.height
                if titleTagWidth != width {
                    printLog("获取图片成功")
                    self?.didGetImageSizeBlock?(width)
                }
            case .failure(let error):
                break
            }
        }
        
        titleTagIV.snp.remakeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo((27.0 - 14.0) / 2.0)
            make.height.equalTo(14)
            make.width.equalTo(titleTagWidth)
        }
    }
}
