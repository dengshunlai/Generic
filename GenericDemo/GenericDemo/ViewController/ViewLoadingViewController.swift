//
//  ViewLoadingViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/3.
//

import UIKit
import Generic

class ViewLoadingViewController: ProjBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var btn1 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("提交", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.orange.cgColor
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(clickBtn1(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var btn2 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.setTitle("登录", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(clickBtn2(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var btn3 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.setTitle("加载", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.blue.cgColor
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(clickBtn3(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var tableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.tableFooterView = UIView.init()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "ViewLoading"
        
        view.addSubview(btn1)
        view.addSubview(btn2)
        view.addSubview(btn3)
        view.addSubview(tableView)
        
        btn1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom).offset(100)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        btn2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn1.snp.bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        btn3.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btn2.snp.bottom).offset(20)
            make.width.equalTo(60)
            make.height.equalTo(30)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).offset(-50)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    @objc func clickBtn1(sender: UIButton) {
        sender.generic.showLoading()
        DBLog("开始网络请求..")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            DBLog("网络请求完毕")
            sender.generic.removeLoading()
        }
    }
    
    @objc func clickBtn2(sender: UIButton) {
        Utils.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            Utils.removeLoading()
        }
    }
    
    @objc func clickBtn3(sender: UIButton) {
        tableView.generic.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.tableView.generic.removeLoading()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }
}

