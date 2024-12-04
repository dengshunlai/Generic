//
//  MenuViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/19.
//

import UIKit
import Generic

class MenuViewController: ProjBaseViewController {
    
    lazy var dismissBtn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("dismiss", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(dismiss(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.lightGray
        
        view.addSubview(dismissBtn)
        
        dismissBtn.snp.makeConstraints { make in
            make.center.equalTo(view)
        }
    }
    
    @objc func dismiss(sender: UIButton) {
        self.dismiss(animated: true)
    }
}

