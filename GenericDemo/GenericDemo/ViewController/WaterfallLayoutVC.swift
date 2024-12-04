//
//  WaterfallLayoutVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/17.
//

import UIKit
import Generic

class WaterfallLayoutVC: ProjBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(LabelItem.self, forCellWithReuseIdentifier: LabelItem.identifier())
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        topBar.titleLabel.text = "瀑布流"
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelItem.identifier(), for: indexPath) as! LabelItem
        if indexPath.row == 0 {
            cell.label.text = "sectionInset & MJRefresh"
        } else if indexPath.row == 1 {
            cell.label.text = "header & footer & lastSection瀑布流"
        } else if indexPath.row == 2 {
            cell.label.text = "段头停留（吸顶）"
        } else if indexPath.row == 3 {
            cell.label.text = "模拟某些段item为0"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = WaterfallLayoutTestVC1()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 1 {
            let vc = WaterfallLayoutTestVC2()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 2 {
            let vc = WaterfallLayoutTestVC3()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.row == 3 {
            let vc = WaterfallLayoutTestVC4()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
