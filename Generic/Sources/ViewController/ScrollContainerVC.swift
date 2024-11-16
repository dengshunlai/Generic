//
//  ScrollContainerVC.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/24.
//

import UIKit

open class ScrollContainerVC: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    open lazy private(set) var cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    open var containerView: UIView {
        get {
            return cv
        }
    }
    
    open var selectedViewController: UIViewController? {
        get {
            if selectedIndex < viewControllers.count {
                return viewControllers[selectedIndex]
            } else {
                return nil
            }
        }
    }
    
    open var selectedIndex: Int = 0 {
        didSet {
            preSelectedIdx = oldValue
            didSetSelectedIndex(selectedIndex)
        }
    }
    
    open private(set) var preSelectedIdx: Int = -1
    
    open var viewControllers: [UIViewController] = [] {
        didSet {
            didSetViewControllers(viewControllers)
        }
    }
    
    open var didScrollToBlock: ((Int) -> Void)?
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cv)
    }
    
    private func didSetViewControllers(_ viewControllers: [UIViewController]) {
        for i in 0...viewControllers.count {
            cv.register(VCItem.self, forCellWithReuseIdentifier: VCItem.identifier(context: "\(type(of: self))_\(i)"))
        }
        cv.reloadData()
        if viewControllers.count > 0 {
            selectedIndex = 0
            cv.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    open func didSetSelectedIndex(_ idx: Int) {
        cv.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VCItem.identifier(context: "\(type(of: self))_\(indexPath.row)"), for: indexPath) as! VCItem
        cell.parentVC = self
        cell.fillCell(vc: viewControllers[indexPath.row])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let idx = lround(scrollView.contentOffset.x / scrollView.frame.size.width)
        selectedIndex = idx
        self.didScrollToBlock?(idx)
    }
}


open class VCItem: BaseCollectionViewCell {
    
    open weak var parentVC: UIViewController?
    open weak var childVC: UIViewController?
    
    open override func setupUI() {
        bottomLine.isHidden = true
    }
    
    open func fillCell(vc: UIViewController) {
        if childVC != nil {
            guard let childVC = childVC else { return }
            childVC.willMove(toParent: nil)
            childVC.view.removeFromSuperview()
            childVC.removeFromParent()
        }
        
        childVC = vc
        guard let childVC = childVC, let parentVC = parentVC else { return }
        parentVC.addChild(childVC)
        contentView.addSubview(childVC.view)
        childVC.didMove(toParent: parentVC)
        childVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            childVC.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            childVC.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            childVC.view.topAnchor.constraint(equalTo: contentView.topAnchor),
            childVC.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}
