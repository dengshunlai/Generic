//
//  TagContainerView.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/26.
//

import UIKit

/// TagContainerView协议
public protocol TagContainerViewDelegate: NSObjectProtocol {
    
    /// 设置tag个数
    /// - Parameter tagContainerView: 控件自身
    /// - Returns: 返回tag个数
    func numberOfTag(in tagContainerView :TagContainerView) -> Int
    
    /// 设置每个tag
    /// - Parameters:
    ///   - tagContainerView: 控件自身
    ///   - index: tag序号
    /// - Returns: 返回的view作为tag
    func tagContainerView(_ tagContainerView :TagContainerView, tagViewFor index: Int) -> UIView
    
    /// 设置每个tag的宽度
    /// - Parameters:
    ///   - tagContainerView: 控件自身
    ///   - index: tag序号
    /// - Returns: 返回tag的宽度
    func tagContainerView(_ tagContainerView :TagContainerView, tagWidthFor index: Int) -> Double
    
    /// 设置所有tag的高度
    /// - Parameter tagContainerView: 控件自身
    /// - Returns: 返回tag的高度
    func tagHeight(for tagContainerView :TagContainerView) -> Double
    
    /// 设置tag的点击事件
    /// - Parameters:
    ///   - tagContainerView: 控件自身
    ///   - index: tag序号
    /// - Returns: 无
    func tagContainerView(_ tagContainerView :TagContainerView, didSelected index: Int) -> Void
}

open class TagContainerView: BaseView {
    
    /// 设置tag的各种属性
    open var option = TagContainerViewOption()
    
    /// 字符串tag数组
    open var tags: [String] = [] {
        didSet {
            refresh()
        }
    }
    
    /// 属性字符串tag数组
    open var attrTags: [NSAttributedString] = [] {
        didSet {
            refresh()
        }
    }
    
    /// tagView数组
    open var tagViewList: [UIView] = []
    
    /// 点击tag的事件
    open var didClickTagBlock: ((Int, TagContainerView) -> Void)?
    
    /// 设置代理，用代理返回tag视图
    open weak var delegate: TagContainerViewDelegate?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(width: Double = kScreenWidth - 30.0) {
        super.init(frame: .zero)
        var width = width
        if width <= 0 {
            width = 50
        }
        option.width = width
    }
    
    open override func setupUI() {
        self.backgroundColor = .clear
    }
    
    open override func refreshContent() {
        for view in tagViewList {
            view.removeFromSuperview()
        }
        tagViewList.removeAll()
        
        if let delegate = delegate {
            let count = delegate.numberOfTag(in: self)
            for index in 0...count {
                let tagView = delegate.tagContainerView(self, tagViewFor: index)
                addSubview(tagView)
                tagViewList.append(tagView)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapTagView(sender:)))
                tagView.addGestureRecognizer(tap)
            }
        } else if attrTags.count > 0 {
            for text in attrTags {
                let tagView = TagView.init(attrText: text, option: option)
                tagView.addTarget(self, action: #selector(clickTagView(sender:)), for: .touchUpInside)
                addSubview(tagView)
                tagViewList.append(tagView)
                
                if tagViewList.count >= option.maxTagCount {
                    break
                }
            }
        } else if tags.count > 0 {
            for text in tags {
                let tagView = TagView.init(text: text, option: option)
                tagView.addTarget(self, action: #selector(clickTagView(sender:)), for: .touchUpInside)
                addSubview(tagView)
                tagViewList.append(tagView)
                
                if tagViewList.count >= option.maxTagCount {
                    break
                }
            }
        }
    }
    
    open override func refreshSizeAndPos() {
        var row: Double = 0.0
        var preView: UIView?
        var index = 0
        for view in tagViewList {
            var tagWidth = 0.0
            var tagHeight = 0.0
            if let delegate = delegate {
                tagWidth = delegate.tagContainerView(self, tagWidthFor: index)
                tagHeight = delegate.tagHeight(for: self)
            } else if tags.count > 0 || attrTags.count > 0 {
                tagWidth = view.intrinsicContentSize.width
                tagHeight = view.intrinsicContentSize.height
            }
            if let preView = preView {
                if CGRectGetMaxX(preView.frame) + option.tagItemSpacing + tagWidth <= option.width - option.edge.right {
                    view.frame = CGRect(x: CGRectGetMaxX(preView.frame) + option.tagItemSpacing,
                                        y: CGRectGetMinY(preView.frame),
                                        width: tagWidth, height: tagHeight)
                } else {
                    row += 1
                    view.frame = CGRect(x: option.edge.left,
                                        y: option.edge.top + row * tagHeight + row * option.tagLineSpacing,
                                        width: tagWidth, height: tagHeight)
                }
            } else {
                view.frame = CGRect(x: option.edge.left,
                                    y: option.edge.top,
                                    width: tagWidth, height: tagHeight)
            }
            preView = view
            index += 1
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        refreshSizeAndPos()
        invalidateIntrinsicContentSize()
    }
    
    open override var intrinsicContentSize: CGSize {
        if let lastTag = tagViewList.last {
            return CGSize(width: option.width, height: CGRectGetMaxY(lastTag.frame) + option.edge.bottom)
        } else {
            return CGSize(width: option.width, height: 30)
        }
    }
    
    open func reloadData() {
        refresh()
    }
    
    @objc func clickTagView(sender: TagView) {
        let idx = tagViewList.firstIndex(where: {$0 === sender})
        if let idx = idx {
            self.didClickTagBlock?(idx, self)
        }
    }
    
    @objc func tapTagView(sender: UITapGestureRecognizer) {
        let idx = tagViewList.firstIndex(where: {$0 === sender.view})
        if let idx = idx, let delegate = delegate {
            delegate.tagContainerView(self, didSelected: idx)
        }
    }
}


open class TagContainerViewOption {
    
    /// 控件的总宽度
    open var width = kScreenWidth - 30.0
    
    /// 内边距
    open var edge = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    /// tag最大个数
    open var maxTagCount = 25
    
    /// tag横向间距
    open var tagItemSpacing = 12.0
    
    /// tag纵向间距
    open var tagLineSpacing = 10.0
    
    /// tag的高度
    open var tagHeight = 30.0
    
    /// tag宽度的填充
    open var tagWidthPadding = 0.0
    
    /// tag的圆角大小
    open var tagCornerRadius = 15.0
    
    /// tag的背景色
    open var tagBackgroundColor = UIColor.generic.hexColor("999999")
    
    /// tag的文本颜色
    open var tagTitleColor = UIColor.generic.hexColor("ffffff")
    
    /// tag的字体
    open var tagFont = UIFont.systemFont(ofSize: 15)
}


open class TagView: UIControl {

    open var label: UILabel!

    open var option: TagContainerViewOption = TagContainerViewOption() {
        didSet {
            refresh()
        }
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(text: String, option: TagContainerViewOption) {
        super.init(frame: .zero)
        initialization()
        self.option = option
        self.label.text = text
        refresh()
    }
    
    public init(attrText: NSAttributedString, option: TagContainerViewOption) {
        super.init(frame: .zero)
        initialization()
        self.option = option
        self.label.attributedText = attrText
        refresh()
    }
    
    func initialization() {
        setupUI()
    }
    
    func setupUI() {
        label = {
            let label = UILabel.init()
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 15)
            label.numberOfLines = 1
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        self.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    open func refreshContent() {
        self.backgroundColor = option.tagBackgroundColor
        self.layer.cornerRadius = option.tagCornerRadius
        self.layer.masksToBounds = true
        self.label.font = option.tagFont
        self.label.textColor = option.tagTitleColor
    }
    
    open func refresh() {
        refreshContent()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: label.intrinsicContentSize.width + option.tagWidthPadding + 20,
                      height: option.tagHeight)
    }
}
