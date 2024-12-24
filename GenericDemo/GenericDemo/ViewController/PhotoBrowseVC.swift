//
//  PhotoBrowseVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/12/24.
//

import UIKit
import Generic

class PhotoBrowseVC: ProjBaseViewController {
    
    lazy var btn = {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage(named: ""), for: .normal)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitle("点击浏览图片", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        self.topBar.titleLabel.text = "PhotoBrowseView"
        
        self.view.addSubview(btn)
        
        NSLayoutConstraint.activate([
            btn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            btn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
    
    @objc func clickBtn() {
        let view = PhotoBrowseView()
        view.imageList = [
            UIImage(named: "cat1")!,
            UIImage(named: "cat2")!,
            UIImage(named: "cat3")!,
            UIImage(named: "sky")!,
        ]
        view.showIn(self.view)
    }
}
