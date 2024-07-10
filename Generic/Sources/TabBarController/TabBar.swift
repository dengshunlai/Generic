//
//  TabBar.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

open class TabBar: UIView {
    
    open var itemList: Array<TabBarItem> = []
    open var topLine: UIView!
    open var onClickItem: ((Int, TabBarItem) -> Void)?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    func initialization() {
        self.backgroundColor = UIColor.white
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        
        topLine = UIView.init()
        topLine.backgroundColor = UIColor.generic.hexColor("e4e4e4")
        topLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLine)
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: self.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let itemHeight = 49.0
        var itemWidth = 0.0
        var itemSpacing = 0.0
        let itemCount = Double(itemList.count)
        if itemList.count <= 4 {
            itemWidth = frame.size.width / 4.0
        } else {
            itemWidth = frame.size.width / itemCount
        }
        if itemList.count <= 3 {
            itemSpacing = (frame.size.width - itemWidth * itemCount) / (itemCount + 1)
        }
        for (idx, item) in itemList.enumerated() {
            let x = itemSpacing + (itemSpacing + itemWidth) * Double(idx)
            item.frame = CGRect(x: x,
                                y: 0,
                                width: itemWidth,
                                height: itemHeight)
        }
    }
    
    open func add(item: TabBarItem) -> Void {
        if itemList.count <= 0 {
            item.isSel = true
        }
        itemList.append(item)
        addSubview(item)
        item.addTarget(self, action: #selector(clickItem(sender:)), for: .touchUpInside)
    }
    
    @objc func clickItem(sender: TabBarItem) -> Void {
        for item in itemList {
            item.isSel = false
        }
        sender.isSel = true
        if let block = onClickItem {
            let idx = itemList.firstIndex(of: sender)
            block(idx!, sender)
        }
    }
}

open class TabBarItem: UIControl {
    
    open var iv :UIImageView!
    open var label: UILabel!
    open var image: UIImage!
    open var selImage: UIImage!
    open var color: UIColor!
    open var selColor: UIColor!
    open var isSel: Bool = false {
        didSet {
            if isSel {
                iv.image = selImage
                label.textColor = selColor
            } else {
                iv.image = image
                label.textColor = color
            }
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public init(text: String, image: UIImage, selImage: UIImage, color: UIColor, selColor: UIColor) {
        super.init(frame: .zero)
        initialization()
        self.label.text = text
        self.image = image
        self.selImage = selImage
        self.color = color
        self.selColor = selColor
        iv.image = image
        label.textColor = color
    }
    
    func initialization() {
        self.backgroundColor = UIColor.clear
        
        iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iv)
        
        label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iv.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            iv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            iv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            iv.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
