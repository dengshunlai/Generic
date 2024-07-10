//
//  TestViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/1.
//

import UIKit
import Generic
import SnapKit

class TestViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var titleTagWidth: Double = 14
    var titleTagLink: String = ""
    
    var testCellTemp: TestCell = TestCell()
    
    lazy var topBar = {
        self.generic.makeNavigationBar(title: "测试")
    }()
    lazy var collectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.identifier())
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(0)
            make.top.equalTo(topBar.snp.bottom).offset(0)
        }
        
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.collectionView.reloadData()
            
            for i in 0...10000 {
                var num = 1
                num += 2
                num += 100
            }
            self.collectionView.reloadData()
            //collectionview 的reloadSection和reloadItems 会自带一个动画， 在这个动画未结束之前调用reloadata 这个reloadata就不会执行
            //注释下面这句就没问题了
//            self.collectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
            
            self.titleTagLink = "https://t8.baidu.com/it/u=518794311,2982917998&fm=193"
            self.collectionView.reloadData()
            self.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCell.identifier(), for: indexPath) as! TestCell
        cell.didGetImageSizeBlock = { [weak self] titleTagWidth in
            self?.titleTagWidth = titleTagWidth
            self?.collectionView.reloadData()
        }
        cell.fillCell(tagLink: titleTagLink, titleTagWidth: titleTagWidth)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        testCellTemp.fillCell(tagLink: titleTagLink, titleTagWidth: titleTagWidth)
        let size = testCellTemp.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: kScreenWidth, height: size.height)
    }
    
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
        printLog("didSelectItemAt: \(indexPath)")
    }
}
