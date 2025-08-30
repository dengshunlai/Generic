//
//  TabBarController.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

open class TabBarController: UITabBarController {
    
    public lazy var aTabBar: TabBar = {
        let tabBar = TabBar.init()
        return tabBar
    }()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialization()
    }
    
    public convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    func initialization() {
        
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isHidden = true
        
        view.addSubview(aTabBar)
            
        aTabBar.onClickItem = { [unowned self] (idx: Int, item: TabBarItem) in
            self.selectedIndex = idx
        }
        
        let tabbarHeight = Utils.safeAreaBottom() + 49
        aTabBar.frame = CGRectMake(0, view.bounds.size.height - tabbarHeight, view.bounds.size.width, tabbarHeight)
    }
}
