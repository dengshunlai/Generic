//
//  BViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import UIKit
import Generic
import SnapKit
import SwiftyJSON

class DViewController: ProjBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
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
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "我的"
        topBar.backBtn.isHidden = true
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
            make.bottom.equalTo(-Utils.tabbarAddBottomHeight())
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.identifier()) as! LabelCell
        if indexPath.row == 0 {
            cell.fillCell(text: "TabContainerVC")
        } else if indexPath.row == 1 {
            cell.fillCell(text: "ScrollContainerVC")
        } else if indexPath.row == 2 {
            cell.fillCell(text: "TagContainerView")
        } else if indexPath.row == 3 {
            cell.fillCell(text: "ToastView")
        } else if indexPath.row == 4 {
            cell.fillCell(text: "ActivityIndicator")
        } else if indexPath.row == 5 {
            cell.fillCell(text: "ViewLoading")
        } else if indexPath.row == 6 {
            cell.fillCell(text: "ViewMessage")
        } else if indexPath.row == 7 {
            cell.fillCell(text: "SegmentTabView")
        } else if indexPath.row == 8 {
            cell.fillCell(text: "NavPageLayout")
        } else if indexPath.row == 9 {
            cell.fillCell(text: "CircleLayout")
        } else if indexPath.row == 10 {
            cell.fillCell(text: "WaterfallLayout")
        } else if indexPath.row == 11 {
            cell.fillCell(text: "TextGradientColor")
        } else if indexPath.row == 12 {
            cell.fillCell(text: "UITextView+Generic")
        } else if indexPath.row == 13 {
            cell.fillCell(text: "CardScrollView")
        } else if indexPath.row == 14 {
            cell.fillCell(text: "NavigationPopCallBack")
        } else if indexPath.row == 15 {
            cell.fillCell(text: "PhotoBrowseVC")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let vc = TabViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = ScrollViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = TagViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = ToastViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 4 {
            let vc = AcIndicatorViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 5 {
            let vc = ViewLoadingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 6 {
            let vc = ViewMsgViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 7 {
            let vc = SegmentTabViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 8 {
            let vc = NavPageLayoutVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 9 {
            let vc = CircleLayoutVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 10 {
            let vc = WaterfallLayoutVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 11 {
            let vc = TextGradientColorVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 12 {
            let vc = UITextViewVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 13 {
            let vc = CardScrollViewVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 14 {
            let vc = PopCallbackVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 15 {
            let vc = PhotoBrowseVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableHeaderView.identifier()) as! TableHeaderView
            header.tableView = tableView
            header.section = section
            return header
        }
        let view = UIView.init()
        view.backgroundColor = UIColor.clear
        return view
    }
}
