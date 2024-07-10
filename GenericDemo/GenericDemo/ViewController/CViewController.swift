//
//  BViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import UIKit
import Generic

class CViewController: ProjBaseViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.estimatedItemSize = CGSize(width: kScreenWidth, height: 50)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TextCell3.self, forCellWithReuseIdentifier: TextCell3.identifier())
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "购物车"
        topBar.backBtn.isHidden = true
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topBar.snp.bottom)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view).offset(-Utils.safeAreaBottom() - 49)
        }
        
        collectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCell3.identifier(), for: indexPath) as! TextCell3
        cell.fillCell(count: indexPath.row + 1)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        可以不实现这个方法
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printLog("\(#function), \(indexPath)")
        let vc = NextViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
