//
//  TagViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/27.
//

import UIKit
import Generic

class TagViewController: ProjBaseViewController {
    
    lazy var tagView1 = {
        let view = TagContainerView(width: kScreenWidth - 30)
        return view
    }()
    lazy var tagView2 = {
        let view = TagContainerView(width: kScreenWidth - 30)
        return view
    }()
    lazy var tagView3 = {
        let view = TagContainerView(width: kScreenWidth - 30)
        view.delegate = self
        return view
    }()
    lazy var myTagViewTemp = {
        let view = MyTagView()
        return view
    }()
    var tagView3TagCount: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.titleLabel.text = "TagContainerView"
        view.addSubview(tagView1)
        view.addSubview(tagView2)
        view.addSubview(tagView3)
        
        tagView1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom).offset(35)
        }
        tagView2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagView1.snp.bottom).offset(35)
        }
        tagView3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tagView2.snp.bottom).offset(35)
        }
        
        //字符串型
        tagView1.tags = ["鸡肉", "菠菜", "西红柿", "超人衣服", "猫" ,"红酒", "iPhone 13 Pro Max", "小米冰箱", "再加一个"]
        
        tagView1.didClickTagBlock = { idx, tagContainer in
            let tag = tagContainer.tags[idx]
            printLog("click idx = \(idx), tag = \(tag)")
            
            if tag == "再加一个" {
                tagContainer.tags.append("加一")
            }
        }
        
        
        //属性字符串型
        let attrStr1 = NSMutableAttributedString(string: " 鸡肉");
        let attachment1 = NSTextAttachment()
        attachment1.image = UIImage(named: "hot")
        attachment1.bounds = CGRect(x: 0, y: -1, width: 15, height: 15)
        attrStr1.insert(NSAttributedString(attachment: attachment1), at: 0)
        
        let attrStr2 = NSMutableAttributedString(string: " 西红柿");
        let attachment2 = NSTextAttachment()
        attachment2.image = UIImage(named: "hot")
        attachment2.bounds = CGRect(x: 0, y: -1, width: 15, height: 15)
        attrStr2.insert(NSAttributedString(attachment: attachment2), at: 0)
        attrStr2.insert(NSAttributedString(attachment: attachment2), at: attrStr2.length)
        
        tagView2.attrTags = [attrStr1, attrStr2]
        
        tagView2.didClickTagBlock = { idx, tagContainer in
            let tag = tagContainer.attrTags[idx]
            printLog("click idx = \(idx), tag = \(tag)")
        }
        
        
        //代理型，tag自定义，更加灵活
        tagView3.reloadData()
    }
}

extension TagViewController: TagContainerViewDelegate {
    
    func numberOfTag(in tagContainerView: TagContainerView) -> Int {
        return tagView3TagCount
    }
    
    func tagContainerView(_ tagContainerView: TagContainerView, tagViewFor index: Int) -> UIView {
        let view = MyTagView()
        view.fillView(imageName: "hot", text: "第\(index)个")
        return view
    }
    
    func tagContainerView(_ tagContainerView: TagContainerView, tagWidthFor index: Int) -> Double {
        myTagViewTemp.fillView(imageName: "hot", text: "第\(index)个")
        let size = myTagViewTemp.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return size.width
    }
    
    func tagHeight(for tagContainerView: TagContainerView) -> Double {
        return 30
    }
    
    func tagContainerView(_ tagContainerView: TagContainerView, didSelected index: Int) {
        printLog("didSelected: \(index)")
        
        //点击第0个再加一个
        if index == 0 && tagContainerView.tagViewList.count < 30 {
            tagView3TagCount += 1
            tagContainerView.reloadData()
        }
    }
}



class MyTagView: BaseView {
    
    lazy var iv = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var label = {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialization()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func initialization() {
        self.backgroundColor = .orange
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = true
        
        self.addSubview(label)
        self.addSubview(iv)
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset((15 + 3) / 2.0)
        }
        iv.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.width.equalTo(15)
            make.height.equalTo(15)
            make.trailing.equalTo(label.snp.leading).offset(-3)
            make.leading.greaterThanOrEqualTo(15).priority(.high)
        }
    }
    
    func fillView(imageName: String, text: String) {
        iv.image = UIImage(named: imageName)
        label.text = text
    }
}
