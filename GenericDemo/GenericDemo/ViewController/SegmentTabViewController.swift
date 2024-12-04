//
//  SegmentTabViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/10.
//

import UIKit
import Generic

class SegmentTabViewController: ProjBaseViewController, UIScrollViewDelegate {
    
    lazy var sgView = {
        let view = SegmentTabView(tabTextList: [])
        view.clickTabBlock = { [weak self] idx in
            self?.scrollView.setContentOffset(CGPoint(x: kScreenWidth * Double(idx), y: 0), animated: true)
        }
        return view
    }()
    lazy var scrollView = {
        let sv = UIScrollView.init()
        sv.backgroundColor = UIColor.white
        sv.isPagingEnabled = true
        sv.delegate = self
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "SegmentTabView"
        
        let view1 = UIView()
        view1.backgroundColor = .cyan
        
        let view2 = UIView()
        view2.backgroundColor = .lightGray
        
        let view3 = UIView()
        view3.backgroundColor = .yellow
        
        let view4 = UIView()
        view4.backgroundColor = .systemPink
        
        view.addSubview(sgView)
        view.addSubview(scrollView)
        scrollView.addSubview(view1)
        scrollView.addSubview(view2)
        scrollView.addSubview(view3)
        scrollView.addSubview(view4)
        
        sgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        scrollView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(sgView.snp.bottom).offset(0)
        }
        
        let scrollViewHeight = kScreenHeight - 44 - Utils.safeAreaTop() - 36
        scrollView.contentSize = CGSize(width: kScreenWidth * 4, height: scrollViewHeight)
        
        view1.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: scrollViewHeight)
        view2.frame = CGRect(x: kScreenWidth, y: 0, width: kScreenWidth, height: scrollViewHeight)
        view3.frame = CGRect(x: kScreenWidth * 2, y: 0, width: kScreenWidth, height: scrollViewHeight)
        view4.frame = CGRect(x: kScreenWidth * 3, y: 0, width: kScreenWidth, height: scrollViewHeight)
        
        sgView.tabTextList = ["商品", "详情", "评论", "推荐"]
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let idx = lround(floor(scrollView.contentOffset.x / kScreenWidth))
        guard idx >= 0 else {
            return
        }
        sgView.setSelectedIdx(idx, animat: true)
    }
}
