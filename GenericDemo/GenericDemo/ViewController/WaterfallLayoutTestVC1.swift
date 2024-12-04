//
//  WaterfallLayoutVC1.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/23.
//

import UIKit
import Generic

class WaterfallLayoutTestVC1: ProjBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateWaterfallLayout {
    
    var dataCount = 10
    
    lazy var waterfallCellTemp = WaterfallCell()
    
    lazy var collectionView = {
        let layout = WaterfallLayout()
        layout.delegate = self//需设置代理
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.generic.hexColor("F5F5F5")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Utils.safeAreaBottom(), right: 0)
        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: WaterfallCell.identifier())
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        topBar.titleLabel.text = "sectionInset & MJRefresh"
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dataCount = 10
                self?.collectionView.mj_header?.endRefreshing()
                self?.collectionView.reloadData()
            }
        })
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dataCount += 10
                self?.collectionView.mj_footer?.endRefreshing()
                self?.collectionView.reloadData()
            }
        })
        
        collectionView.reloadData()
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallCell.identifier(), for: indexPath) as! WaterfallCell
        cell.fillCell(index: indexPath.row)
        return cell
    }
    
    //MARK: UICollectionViewDelegateWaterfallLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, columnCountForSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        waterfallCellTemp.fillCell(index: indexPath.row)
        let size = waterfallCellTemp.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let width = (kScreenWidth - 20 - 10) / 2
        return CGSize(width: width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, columnSpacingForSection section: Int) -> Double {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, lineSpacingForSection section: Int) -> Double {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, insetForSection section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DBLog("\(indexPath.row)")
    }
}

