//
//  SegmentTabView.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/10.
//

import UIKit

open class SegmentTabView: BaseView {
    
    public var option = SegmentTabViewOption()
    
    public var clickTabBlock: ((Int)->Void)?
    
    private(set) var selectedIdx = 0
    
    public var tabTextList: [String] = [] {
        didSet {
            refresh()
        }
    }
    
    public var btnList: [UIButton] = []
    
    public var indicatorLine: UIView!
    
    public var indicatorConstraints: [NSLayoutConstraint] = []
    
    public var bottomLine: UIView!
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(tabTextList: [String]) {
        super.init(frame: .zero)
        self.tabTextList = tabTextList
    }
    
    open override func setupUI() {
        self.backgroundColor = option.backgroundColor
        
        indicatorLine = {
            let view = UIView.init()
            view.backgroundColor = option.indicatorColor
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        bottomLine = {
            let view = UIView.init()
            view.backgroundColor = option.bottomLineColor
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        addSubview(indicatorLine)
        addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 0.5),
        ])
    }
    
    open override func refreshContent() {
        self.backgroundColor = option.backgroundColor
        indicatorLine.backgroundColor = option.indicatorColor
        bottomLine.backgroundColor = option.bottomLineColor
        
        for btn in btnList {
            btn.removeFromSuperview()
        }
        btnList.removeAll()
        
        for text in tabTextList {
            let btn = UIButton.init(type: .custom)
            btn.setTitleColor(option.tabTextColor, for: .normal)
            btn.setTitleColor(option.selectedTabTextColor, for: .selected)
            btn.setTitle(text, for: .normal)
            btn.titleLabel?.font = option.tabFont
            btn.addTarget(self, action: #selector(clickBtn(sender:)), for: .touchUpInside)
            addSubview(btn)
            btnList.append(btn)
        }
        setSelectedIdx(0, animat: false)
    }
    
    open override func refreshSizeAndPos() {
        if btnList.count <= 0 {
            return
        }
        let btnWidth = intrinsicContentSize.width / Double(btnList.count)
        
        var preBtn: UIButton?
        for btn in btnList {
            if let preBtn = preBtn {
                btn.frame = CGRectMake(CGRectGetMaxX(preBtn.frame), 0, btnWidth, self.frame.size.height)
            } else {
                btn.frame = CGRectMake(0, 0, btnWidth, self.frame.size.height)
            }
            preBtn = btn
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        refreshSizeAndPos()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: kScreenWidth, height: 36)
    }
    
    @objc func clickBtn(sender: UIButton) {
        let idx = btnList.firstIndex(of: sender)
        guard let idx = idx else { return }
        setSelectedIdx(idx)
        self.clickTabBlock?(idx)
    }
    
    public func setSelectedIdx(_ idx: Int, animat: Bool = true) {
        if idx < 0 || idx >= btnList.count {
            return
        }
        self.selectedIdx = idx
        for btn in btnList {
            btn.isSelected = false
        }
        btnList[idx].isSelected = true
        indicatorMoveTo(idx: idx, animat: animat)
    }
    
    public func indicatorMoveTo(idx: Int, animat: Bool = true) {
        if btnList.count < idx {
            return
        }
        let btn = btnList[idx]
        
        NSLayoutConstraint.deactivate(indicatorConstraints)
        let constraints = [
            indicatorLine.centerXAnchor.constraint(equalTo: btn.centerXAnchor),
            indicatorLine.bottomAnchor.constraint(equalTo: btn.bottomAnchor),
            indicatorLine.heightAnchor.constraint(equalToConstant: option.indicatorHeight),
            indicatorLine.widthAnchor.constraint(equalToConstant: option.indicatorWidth),
        ]
        NSLayoutConstraint.activate(constraints)
        indicatorConstraints = constraints
        if animat {
            UIView.animate(withDuration: 0.2) {
                self.layoutIfNeeded()
            }
        }
    }
}


open class SegmentTabViewOption {
    
    /// 指示器颜色
    open var indicatorColor = UIColor.orange
    
    /// 指示器宽度
    open var indicatorWidth = 20.0
    
    /// 指示器高度
    open var indicatorHeight = 2.0
    
    /// tab的字体
    open var tabFont = UIFont.systemFont(ofSize: 14)
    
    /// tab文字颜色
    open var tabTextColor = UIColor.generic.hexColor("666666")
    
    /// 选中的tab文字颜色
    open var selectedTabTextColor = UIColor.generic.hexColor("333333")
    
    /// 控件背景色
    open var backgroundColor = UIColor.white
    
    /// 底部线的颜色
    open var bottomLineColor = UIColor.generic.hexColor("e4e4e4")
}
