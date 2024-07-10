//
//  TabBarController.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

open class TabBarController: UITabBarController {
    
    public var aTabBar: TabBar!
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialization()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initialization() {
        tabBar.isHidden = true
        aTabBar = TabBar.init()
        view.addSubview(aTabBar)
            
        aTabBar.onClickItem = { [unowned self] (idx: Int, item: TabBarItem) in
            self.selectedIndex = idx
        }
        
        let tabbarHeight = Utils.safeAreaBottom() + 49
        aTabBar.frame = CGRectMake(0, view.bounds.size.height - tabbarHeight, view.bounds.size.width, tabbarHeight)
    }
}
