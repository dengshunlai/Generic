//
//  WaterfallLayoutTestVC4.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/7/2.
//

import UIKit
import Generic

class WaterfallLayoutTestVC4: ProjBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateWaterfallLayout {
    
    var itemCount: Int = 12
    
    lazy var waterfallCellTemp = WaterfallCell()
    
    lazy var reloadDataBtn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.generic.hexColor("333333"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitle("reload", for: .normal)
        btn.addTarget(self, action: #selector(clickReloadDataBtn), for: .touchUpInside)
        return btn
    }()
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
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier())
        collectionView.register(ImgCell.self, forCellWithReuseIdentifier: ImgCell.identifier())
        collectionView.register(CollectionHeader.self, forSupplementaryViewOfKind: WaterfallLayout.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier())
        collectionView.register(CollectionFooter.self, forSupplementaryViewOfKind: WaterfallLayout.elementKindSectionFooter, withReuseIdentifier: CollectionFooter.identifier())
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        topBar.titleLabel.text = "某些段item为0"
        
        topBar.addSubview(reloadDataBtn)
        view.addSubview(collectionView)
        
        reloadDataBtn.snp.makeConstraints { make in
            make.leading.equalTo(topBar.backBtn.snp.trailing).offset(12)
            make.centerY.equalTo(topBar.backBtn)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(topBar.snp.bottom)
        }
        
        collectionView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.collectionView.mj_header?.endRefreshing()
                self?.itemCount = 12
                self?.collectionView.reloadData()
            }
        })
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.collectionView.mj_footer?.endRefreshing()
                self?.itemCount += 12
                self?.collectionView.reloadData()
            }
        })
        
        collectionView.reloadData()
    }
    
    @objc func clickReloadDataBtn() {
        collectionView.reloadData()
        ToastView.showText(text: "刷新成功")
    }
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 0
        } else if section == 2 {
            return 0
        } else if section == 3 {
            return itemCount
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier(), for: indexPath) as! BannerCell
            cell.fillCell(idx: indexPath.row)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier(), for: indexPath) as! BannerCell
            cell.fillCell(idx: indexPath.row)
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImgCell.identifier(), for: indexPath) as! ImgCell
            cell.fillCell(imgName: "cat\(indexPath.row + 1)")
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallCell.identifier(), for: indexPath) as! WaterfallCell
            cell.fillCell(index: indexPath.row)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == WaterfallLayout.elementKindSectionHeader {
            if indexPath.section == 0 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: WaterfallLayout.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier(), for: indexPath) as! CollectionHeader
                header.titleLabel.text = "最新消息（吸顶）"
                return header
            } else if indexPath.section == 1 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: WaterfallLayout.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier(), for: indexPath) as! CollectionHeader
                header.titleLabel.text = "最强军团"
                return header
            } else if indexPath.section == 2 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: WaterfallLayout.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier(), for: indexPath) as! CollectionHeader
                header.titleLabel.text = "这是喵喵喵喵~~~~"
                return header
            } else if indexPath.section == 3 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: WaterfallLayout.elementKindSectionHeader, withReuseIdentifier: CollectionHeader.identifier(), for: indexPath) as! CollectionHeader
                header.titleLabel.text = "下面是瀑布流（吸顶）"
                return header
            }
        } else if kind == WaterfallLayout.elementKindSectionFooter {
            if indexPath.section == 1 {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: WaterfallLayout.elementKindSectionFooter, withReuseIdentifier: CollectionFooter.identifier(), for: indexPath) as! CollectionFooter
                header.titleLabel.text = "底部建筑"
                return header
            }
        }
        return UICollectionReusableView()
    }
    
    //MARK: UICollectionViewDelegateWaterfallLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, columnCountForSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else if section == 2 {
            return 3
        } else if section == 3 {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSizeMake(kScreenWidth - 20, 80)
        } else if indexPath.section == 1 {
            return CGSizeMake(kScreenWidth - 20, 80)
        } else if indexPath.section == 2 {
            let width = (kScreenWidth - 40) / 3
            return CGSizeMake(width, width)
        } else if indexPath.section == 3 {
            waterfallCellTemp.fillCell(index: indexPath.row)
            let size = waterfallCellTemp.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            let width = (kScreenWidth - 20 - 10) / 2
            return CGSize(width: width, height: size.height)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, columnSpacingForSection section: Int) -> Double {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, lineSpacingForSection section: Int) -> Double {
        if section == 1 {
            return 5
        }
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, insetForSection section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        } else if section == 1 {
            return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        } else if section == 2 {
            return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        } else if section == 3 {
            return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, heightForHeaderInSection section: Int) -> Double {
        if section == 0 {
            return 35
        } else if section == 1 {
            return 30
        } else if section == 2 {
            return 50
        } else if section == 3 {
            return 30
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, insetForHeaderInSection section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        } else if section == 1 {
            return UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10)
        } else if section == 2 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        } else if section == 3 {
            return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, heightForFooterInSection section: Int) -> Double {
        if section == 1 {
           return 25
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout, insetForFooterInSection section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        }
        return .zero
    }
    
    func headerFloatForSections(_ collectionView: UICollectionView, layout collectionViewLayout: WaterfallLayout) -> [Int] {
        return [0, 1, 2, 3]
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DBLog("\(indexPath.section)-\(indexPath.row)")
    }
}

