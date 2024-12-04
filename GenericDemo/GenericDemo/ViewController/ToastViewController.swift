//
//  ToastViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/1.
//

import UIKit
import Generic
import SnapKit
import SwiftyJSON

class ToastViewController: ProjBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.tableFooterView = UIView.init()
        tableView.register(LabelCell.self, forCellReuseIdentifier: LabelCell.identifier())
        tableView.register(TableHeaderView.self, forHeaderFooterViewReuseIdentifier: TableHeaderView.identifier())
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "ToastView"
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.identifier()) as! LabelCell
        if indexPath.row == 0 {
            cell.fillCell(text: "中间")
        } else if indexPath.row == 1 {
            cell.fillCell(text: "中间")
        } else if indexPath.row == 2 {
            cell.fillCell(text: "中间")
        } else if indexPath.row == 3 {
            cell.fillCell(text: "中间")
        } else if indexPath.row == 4 {
            cell.fillCell(text: "中间")
        } else if indexPath.row == 5 {
            cell.fillCell(text: "底部")
        } else if indexPath.row == 6 {
            cell.fillCell(text: "底部")
        } else if indexPath.row == 7 {
            cell.fillCell(text: "顶部")
        } else if indexPath.row == 8 {
            cell.fillCell(text: "顶部")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            ToastView.showText(text: "上存成功")
        } else if indexPath.row == 1 {
            ToastView.showText(text: "加载成功\n换行显示")
        } else if indexPath.row == 2 {
            ToastView.showText(text: "加载成功\n换行显示\n继续换行")
        } else if indexPath.row == 3 {
            ToastView.showText(text: "很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长")
        } else if indexPath.row == 4 {
            ToastView.showText(text: "很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长很长")
        } else if indexPath.row == 5 {
            ToastView.showText(text: "加载成功", position: .bottom)
        } else if indexPath.row == 6 {
            ToastView.showText(text: "账号错误\n请重新输入", position: .bottom)
        } else if indexPath.row == 7 {
            ToastView.showText(text: "加载成功", position: .top)
        } else if indexPath.row == 8 {
            ToastView.showText(text: "账号错误\n请重新输入", position: .top)
        }
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

