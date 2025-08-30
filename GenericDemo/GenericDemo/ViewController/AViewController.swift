//
//  AViewController.swift
//  SwiftProj
//
//  Created by 邓顺来1992 on 2024/5/4.
//

import UIKit
import Generic

class AViewController: ProjBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView = {
        let tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.tableFooterView = UIView.init()
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier())
        return tableView
    }()
    lazy var tempTextCell = TextCell()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "首页"
        topBar.backBtn.isHidden = true
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view).offset(-Utils.safeAreaBottom() - 49)
        }
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier(), for: indexPath) as! TextCell
        cell.fillCell(count: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tempTextCell.fillCell(count: indexPath.row + 1)
        let height = tempTextCell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        return height
        //用这个也行，要设置estimatedRowHeight
        //return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = NextViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
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
