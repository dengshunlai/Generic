//
//  UITextViewVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/7/6.
//

import UIKit
import Generic

class UITextViewVC: ProjBaseViewController {
    
    lazy var textView1 = {
        let textView = UITextView.init()
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.returnKeyType = .done
        textView.autocorrectionType = .no
        textView.spellCheckingType = .no
        textView.autocapitalizationType = .none
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 35))
        let done = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(done))
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [space, done]
        textView.inputAccessoryView = toolbar
        textView.layer.cornerRadius = 8
        textView.layer.masksToBounds = true
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.lightGray.cgColor
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        topBar.titleLabel.text = "Placeholder + MaxLength"
        
        view.addSubview(textView1)
        
        textView1.generic.setPlaceholder("请输入内容~")
        textView1.generic.setMaxLength(length: 20)
        
        textView1.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(150)
            make.top.equalTo(topBar.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func done() {
        view.endEditing(true)
    }
}
