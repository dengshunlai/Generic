//
//  ViewMsgViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/10.
//

import UIKit
import Generic

class ViewMsgViewController: ProjBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var btn1 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("请求数据", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(clickBtn1(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var btn2 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("更多", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.addTarget(self, action: #selector(clickBtn2(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var btn3 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.orange, for: .normal)
        btn.setTitle("单文字", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
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
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "ViewMessage"
        
        topBar.addSubview(btn1)
        topBar.addSubview(btn2)
        topBar.addSubview(btn3)
        view.addSubview(tableView)
        
        btn1.snp.makeConstraints { make in
            make.centerY.equalTo(topBar.backBtn)
            make.trailing.equalTo(-10)
        }
        btn2.snp.makeConstraints { make in
            make.centerY.equalTo(topBar.backBtn)
            make.trailing.equalTo(btn1.snp.leading).offset(-10)
        }
        btn3.snp.makeConstraints { make in
            make.centerY.equalTo(topBar.backBtn)
            make.leading.equalTo(topBar.backBtn.snp.trailing).offset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom).offset(0)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
        }
    }
    
    override func setupOther() {
        requestData()
    }
    
    func requestData() {
        tableView.generic.removeMessage()
        tableView.generic.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.generic.removeLoading()
            self.tableView.generic.showMessage(image: UIImage(named: "error"), message: "暂无数据")
        }
    }
    
    @objc func clickBtn1(sender: UIButton) {
        requestData()
    }
    
    @objc func clickBtn2(sender: UIButton) {
        tableView.generic.removeMessage()
        tableView.generic.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.generic.removeLoading()
            self.tableView.generic.showMessage(image: UIImage(named: "error"), 
                                               message: "暂无数据",
                                               subMessage: "请再次加载试试",
                                               buttonText: "点击加载",
                                               buttonClickBlock: { [weak self] msgView in
                self?.requestData()
            } , yOffset: -30)
        }
    }
    
    @objc func clickBtn3(sender: UIButton) {
        tableView.generic.removeMessage()
        tableView.generic.showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.generic.removeLoading()
            self.tableView.generic.showMessage(message: "暂无数据",
                                               subMessage: "请检测网络状态",
                                               yOffset: -30)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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

