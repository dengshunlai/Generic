//
//  ActivityIndicatorVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/1.
//

import UIKit
import Generic

class AcIndicatorViewController: ProjBaseViewController {
    
    lazy var type0Btn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("type_0", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 0
        btn.addTarget(self, action: #selector(clickTypeBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var type1Btn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("type_1", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 1
        btn.addTarget(self, action: #selector(clickTypeBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var type2Btn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("type_2", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 2
        btn.addTarget(self, action: #selector(clickTypeBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var type3Btn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("type_3", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 3
        btn.addTarget(self, action: #selector(clickTypeBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var type4Btn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("type_4", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.tag = 4
        btn.addTarget(self, action: #selector(clickTypeBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var activityIndicator = {
        let view = ActivityIndicator(style: .style_0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "ActivityIndicator"
        topBar.titleLabel.isHidden = false
        
        view.addSubview(type0Btn)
        view.addSubview(type1Btn)
        view.addSubview(type2Btn)
        view.addSubview(type3Btn)
        view.addSubview(type4Btn)
        
        view.addSubview(activityIndicator)
        
        type0Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(topBar.snp.bottom).offset(15)
        }
        type1Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(type0Btn.snp.bottom).offset(10)
        }
        type2Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(type1Btn.snp.bottom).offset(10)
        }
        type3Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(type2Btn.snp.bottom).offset(10)
        }
        type4Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(type3Btn.snp.bottom).offset(10)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(50)
        }
    }
    
    @objc func clickTypeBtn(sender: UIButton) {
        activityIndicator.style = ActivityIndicatorStyle(rawValue: sender.tag)!
        activityIndicator.starAnimation()
    }
}
