//
//  CardScrollViewVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/7/7.
//

import UIKit
import Generic

class CardScrollViewVC: ProjBaseViewController, CardScrollViewDelegate {
    
    lazy var cardScrollView1 = {
        let view = CardScrollView()
        view.delegate = self
        return view
    }()
    lazy var btn1 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("到第3张去", for: .normal)
        btn.addTarget(self, action: #selector(clickBtn1), for: .touchUpInside)
        return btn
    }()
    lazy var cardScrollView2 = {
        let view = CardScrollView()
        view.itemSize = CGSizeMake(315, 145)
        view.option.style = .scale
        view.delegate = self
        return view
    }()
    lazy var cardScrollView3 = {
        let view = CardScrollView()
        view.scrollSize = CGSizeMake(250, 145)
        view.itemSize = CGSizeMake(280, 145)
        if #available(iOS 13, *) {
            view.option.style = .yRotation
        }
        view.delegate = self
        return view
    }()
    lazy var btn2 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("到第4张去", for: .normal)
        btn.addTarget(self, action: #selector(clickBtn2), for: .touchUpInside)
        return btn
    }()
    lazy var loopBtn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.generic.hexColor("333333"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("设置循环", for: .normal)
        btn.addTarget(self, action: #selector(clickLoopBtn), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.titleLabel.text = "CardScrollView"
        
        view.addSubview(cardScrollView1)
        view.addSubview(btn1)
        view.addSubview(cardScrollView2)
        view.addSubview(cardScrollView3)
        view.addSubview(btn2)
        topBar.addSubview(loopBtn)
        
        cardScrollView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom).offset(30)
        }
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardScrollView1.snp.bottom).offset(15)
        }
        cardScrollView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn1.snp.bottom).offset(30)
        }
        cardScrollView3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardScrollView2.snp.bottom).offset(30)
            make.height.equalTo(200)
        }
        btn2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cardScrollView3.snp.bottom).offset(15)
        }
        loopBtn.snp.makeConstraints { make in
            make.centerY.equalTo(topBar.backBtn)
            make.trailing.equalTo(-10)
        }
        
        cardScrollView1.didScrollToIndex = { (view, index) in
            printLog("cardScrollView1 index = \(index)")
        }
        cardScrollView2.didScrollToIndex = { (view, index) in
            printLog("cardScrollView2 index = \(index)")
        }
        cardScrollView3.didScrollToIndex = { (view, index) in
            printLog("cardScrollView3 index = \(index)")
        }
        
        cardScrollView1.reloadData()
        cardScrollView2.reloadData()
        cardScrollView3.reloadData()
    }
    
    @objc func clickBtn1() {
        cardScrollView1.scrollToIndex(2)
    }
    
    @objc func clickBtn2() {
        cardScrollView3.scrollToIndex(3)
    }
    
    @objc func clickLoopBtn() {
        cardScrollView1.isLoop = !cardScrollView1.isLoop
        cardScrollView2.isLoop = !cardScrollView2.isLoop
        cardScrollView3.isLoop = !cardScrollView3.isLoop
        
        cardScrollView1.reloadData()
        cardScrollView2.reloadData()
        cardScrollView3.reloadData()
        
        if cardScrollView1.isLoop {
            loopBtn.setTitle("取消循环", for: .normal)
        } else {
            loopBtn.setTitle("设置循环", for: .normal)
        }
    }
    
    //MARK: CardScrollViewDelegate
    func numberOfItem(in cardScrollView: CardScrollView) -> Int {
        if cardScrollView == cardScrollView1 {
            return 5
        } else if cardScrollView == cardScrollView2 {
            return 5
        } else if cardScrollView == cardScrollView3 {
            return 5
        }
        return 0
    }
    
    func cardScrollView(_ cardScrollView: CardScrollView, itemForIndex index: Int) -> UIView {
        if cardScrollView == cardScrollView1 {
            let view = CardView()
            view.fillView(index: index)
            return view
        } else if cardScrollView == cardScrollView2 {
            let view = CardView()
            view.fillView(index: index)
            return view
        } else if cardScrollView == cardScrollView3 {
            let view = CardView()
            view.fillView(index: index)
            return view
        }
        return UIView()
    }
    
    func cardScrollView(_ cardScrollView: CardScrollView, didSelectedIndex index: Int) {
        printLog("click \(index)")
    }
}
