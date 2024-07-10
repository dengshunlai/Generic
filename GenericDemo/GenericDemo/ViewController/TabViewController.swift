//
//  MyTabViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/23.
//

import UIKit
import Generic

class TabViewController: TabContainerVC {
    
    lazy var sg = {
        let sg = UISegmentedControl(items: ["A控制器","B控制器","C控制器"])
        sg.selectedSegmentIndex = 0
        sg.setTitleTextAttributes([.foregroundColor: UIColor.systemPink], for: .selected)
        sg.addTarget(self, action: #selector(sgValueChange(sender:)), for: .valueChanged)
        return sg
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        topBar.titleLabel.isHidden = true
        
        topBar.addSubview(sg)
        
        sg.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(Utils.safeAreaTop() + 44 / 2.0)
        }
        self.containerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.orange
        
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.blue
        
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.green
        
        self.viewControllers = [vc1, vc2, vc3]
    }
    
    @objc func sgValueChange(sender: UISegmentedControl) {
        self.tc.selectedIndex = sender.selectedSegmentIndex
    }
}


