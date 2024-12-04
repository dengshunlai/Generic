//
//  CircleLayoutVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/6/16.
//

import UIKit
import Generic

class CircleLayoutVC: ProjBaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateCircleLayout, CAAnimationDelegate {
    
    var rotationFromAngle: Double = 0
    var isRotating = false
    
    lazy var cLayout = {
        let layout = CircleLayout()
        layout.itemSize = CGSizeMake(50, 80)
        layout.itemOffset = 0
        return layout
    }()
    lazy var collectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: cLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(NavIconCell.self, forCellWithReuseIdentifier: NavIconCell.identifier())
        return collectionView
    }()
    lazy var arrowLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "↑||||||"
        return label
    }()
    lazy var rotateBtn = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.generic.hexColor("333333"), for: .normal)
        btn.setTitle("随机转动", for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.generic.hexColor("e4e4e4").cgColor
        btn.addTarget(self, action: #selector(clickRotateBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var rotateBtn2 = {
        let btn = UIButton.init(type: .custom)
        btn.setTitleColor(UIColor.generic.hexColor("333333"), for: .normal)
        btn.setTitle("指定转动", for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.generic.hexColor("e4e4e4").cgColor
        btn.addTarget(self, action: #selector(clickRotateBtn2(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        topBar.titleLabel.text = "CircleLayout"
        
        view.addSubview(collectionView)
        view.addSubview(arrowLabel)
        view.addSubview(rotateBtn)
        view.addSubview(rotateBtn2)
        
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(topBar.snp.bottom).offset(24)
            make.height.equalTo(collectionView.snp.width)
        }
        arrowLabel.snp.makeConstraints { make in
            make.center.equalTo(collectionView)
            make.width.equalTo(5)
        }
        rotateBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom).offset(100)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        rotateBtn2.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rotateBtn.snp.bottom).offset(15)
            make.width.equalTo(rotateBtn)
            make.height.equalTo(rotateBtn)
        }
    }
    
    @objc func clickRotateBtn(sender: UIButton) {
        cLayout.rotate()
    }
    
    @objc func clickRotateBtn2(sender: UIButton) {
        cLayout.rotateTo(index: 5, additionalRoundRange: 1..<5)
    }
        
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NavIconCell.identifier(), for: indexPath) as! NavIconCell
        cell.fillCell()
        cell.label.text = "\(indexPath.row)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DBLog("click: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        DBLog("willDisplay: \(indexPath.row)")
    }
    
    //MARK: UICollectionViewDelegateCircleLayout
    
    func collectionView(_ collectionView: UICollectionView, layout: CircleLayout, isBeginRotation: Bool) {
        DBLog("isBeginRotation")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: CircleLayout, isEndRotation: Bool) {
        DBLog("isEndRotation: \(layout.selectedIndex)")
    }
}

