//
//  NavPageLayoutVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/12.
//

import UIKit
import Generic

class NavPageLayoutVC: ProjBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView = {
        let layout = NavPageLayout()
        layout.perRowItemCount = 5
        layout.rowCount = 2
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NavIconCell.self, forCellWithReuseIdentifier: NavIconCell.identifier())
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topBar.titleLabel.text = "NavPageLayout"
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(topBar.snp.bottom).offset(24)
            make.height.equalTo(160 + 10)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavIconCell.identifier(), for: indexPath) as! NavIconCell
        cell.fillCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (kScreenWidth - 24 - 5 * 4) / 5
        return CGSize(width: width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printLog("click: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        printLog("willDisplay: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        printLog("didEndDisplaying: \(indexPath.row)")
    }
}


class NavIconCell: BaseCollectionViewCell {
    
    var iconPathList = ["icon_1.jpg", "icon_2.jpg", "icon_3.jpg", "icon_4.jpg", "icon_5.jpg",
                        "icon_6.jpg", "icon_7.jpg", "icon_8.jpg", "icon_9.jpg", "icon_10.jpg"]
    
    lazy var icon = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        return iv
    }()
    lazy var label = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("33333")
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    override func setupUI() {
        bottomLine.isHidden = true
        contentView.addSubview(icon)
        contentView.addSubview(label)
        
        icon.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.top.equalTo(8)
        }
        label.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
    }
    
    func fillCell() {
        let idx = Int(arc4random_uniform(UInt32(iconPathList.count)))
        icon.image = UIImage(named: iconPathList[idx])
        
        label.text = "这是标题"
    }
}
