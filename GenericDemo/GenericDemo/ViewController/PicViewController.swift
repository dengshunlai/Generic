//
//  PicViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/22.
//

import UIKit
import Generic

class PicViewController: ProjBaseViewController {

    lazy var iv = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "1.jpeg")
        iv.bounds = CGRect(x: 0, y: 0, width: 300, height: 300 * 872.0 / 658)
        iv.center = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 - Utils.safeAreaTop() / 2)
        return iv
    }()
    lazy var dismissBtn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("dismiss", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(dismiss(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "图片"
        
        view.addSubview(iv)
        view.addSubview(dismissBtn)
        
        dismissBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-150)
        }
    }
    
    @objc func dismiss(sender: UIButton) {
        self.dismiss(animated: true)
    }
}

