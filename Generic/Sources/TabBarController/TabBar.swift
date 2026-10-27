//
//  TabBar.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

open class TabBar: BaseView {
    
    open var itemList: Array<TabBarItem> = []
    open var onClickItem: ((Int, TabBarItem) -> Void)?
    
    public private(set) lazy var topLine = {
        let view = UIView.init()
        view.backgroundColor = UIColor.generic.hexColor("e4e4e4")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    open override func setupUI() {
        self.backgroundColor = UIColor.white
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        
        addSubview(topLine)
        
        NSLayoutConstraint.activate([
            topLine.topAnchor.constraint(equalTo: self.topAnchor),
            topLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            topLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            topLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    open override func refreshSizeAndPos() {
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        refreshSizeAndPos()
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
            if let idx = itemList.firstIndex(of: sender) {
                block(idx, sender)
            }
        }
    }
}

open class TabBarItem: UIControl {
    
    public private(set) lazy var iv = {
        let view = UIImageView.init()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    public private(set) lazy var label = {
        let label = UILabel.init()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    public private(set) var badgeLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = UIColor.generic.hexColor("DF4040")
        label.layer.cornerRadius = 7
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public var badgeOffset = CGPoint(x: 13, y: -15)
    public lazy var badgeWidthConstraint = badgeLabel.widthAnchor.constraint(equalToConstant: 20)
    
    public private(set) var image: UIImage?
    public private(set) var selImage: UIImage?
    public private(set) var color: UIColor?
    public private(set) var selColor: UIColor?
    
    public var isSel: Bool = false {
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
    }
    
    public init(text: String?, image: UIImage?, selImage: UIImage?, color: UIColor?, selColor: UIColor?) {
        self.image = image
        self.selImage = selImage
        self.color = color
        self.selColor = selColor
        
        super.init(frame: .zero)
        
        self.initialization()
        self.label.text = text
        self.label.textColor = color
        self.iv.image = image
    }
    
    func initialization() {
        setupUI()
    }
    
    func setupUI() {
        self.backgroundColor = UIColor.clear
        
        addSubview(iv)
        addSubview(label)
        addSubview(badgeLabel)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 0)
        ])
        NSLayoutConstraint.activate([
            iv.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            iv.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            iv.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            iv.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            iv.heightAnchor.constraint(equalToConstant: 22)
        ])
        NSLayoutConstraint.activate([
            badgeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: badgeOffset.x),
            badgeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: badgeOffset.y),
            badgeLabel.heightAnchor.constraint(equalToConstant: 14),
            badgeWidthConstraint
        ])
        
        badgeLabel.isHidden = true
    }
    
    public func setBadge(_ text: String?) {
        badgeLabel.text = text
        
        if text?.count ?? 0 > 0 {
            var width = 14.0
            if text?.count ?? 0 > 1 {
                width = badgeLabel.sizeThatFits(UIView.layoutFittingCompressedSize).width + 8.0
            }
            badgeWidthConstraint.constant = width
            badgeLabel.isHidden = false
        } else {
            badgeLabel.isHidden = true
        }
    }
}
