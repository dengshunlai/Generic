//
//  PopCallbackVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/11/16.
//

import UIKit
import Generic

class PopCallbackVC: ProjBaseViewController, UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.titleLabel.text = "NavigationPopCallback"
        
        //手势返回触发的回调
        self.gesturePopCallback = { [weak self] in
            let alert = UIAlertView(title: "是否放弃支付？",
                                    message: "支付成功能够返现50%！", delegate: nil, cancelButtonTitle: "继续支付")
            alert.addButton(withTitle: "放弃支付");
            alert.delegate = self
            alert.show()
            return false
        }
        //点击返回按钮触发的回调
        topBar.onClickBack = { [weak self] in
            let alert = UIAlertView(title: "是否放弃支付？", 
                                    message: "支付成功能够返现50%！", delegate: nil, cancelButtonTitle: "继续支付")
            alert.addButton(withTitle: "放弃支付");
            alert.delegate = self
            alert.show()
            return false
        }
    }
    
    //MARK: UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
