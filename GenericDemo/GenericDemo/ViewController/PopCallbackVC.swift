//
//  PopCallbackVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/11/16.
//

import UIKit
import Generic

class PopCallbackVC: ProjBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        topBar.titleLabel.text = "NavigationPopCallback"
    }
    
    override func setupOther() {
        //手势返回触发的回调
        self.gesturePopCallback = { [weak self] in
            let alert = UIAlertController(title: "是否放弃支付？",
                                          message: "支付成功能够返现50%！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "继续支付", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "放弃支付", style: .default, handler: { _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true)
            return false
        }
        //点击返回按钮触发的回调
        topBar.onClickBack = { [weak self] in
            let alert = UIAlertController(title: "是否放弃支付？",
                                          message: "支付成功能够返现50%！", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "继续支付", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "放弃支付", style: .default, handler: { _ in
                self?.navigationController?.popViewController(animated: true)
            }))
            self?.present(alert, animated: true)
            return false
        }
    }
}
