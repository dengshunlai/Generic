//
//  BViewController.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import UIKit
import Generic

class NextViewController: ProjBaseViewController {
    
    lazy var popBtn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("Pop", for: .normal)
        btn.addTarget(self, action: #selector(clickPopBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present1Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场1(tap)", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent1Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present2Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场2(pan)", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent2Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present3Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场3", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent3Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present4Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场4", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent4Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present5Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场5", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent5Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present6Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场6(tap)", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent6Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present7Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场7(tap)", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent7Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present8Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场8", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent8Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present9Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场9(tap+pan)", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent9Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var present10Btn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("转场10(tap)", for: .normal)
        btn.addTarget(self, action: #selector(clickPresent10Btn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var presentNormalBtn = {
        let btn = UIButton.init(type: .system)
        btn.setTitle("普通转场", for: .normal)
        btn.addTarget(self, action: #selector(clickPresentNorBtn(sender:)), for: .touchUpInside)
        return btn
    }()
    lazy var picIV = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "1.jpeg")
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        view.backgroundColor = UIColor.white
        topBar.titleLabel.text = "商品详情"

        view.addSubview(popBtn)
        view.addSubview(present1Btn)
        view.addSubview(present2Btn)
        view.addSubview(present3Btn)
        view.addSubview(present4Btn)
        view.addSubview(present5Btn)
        view.addSubview(present6Btn)
        view.addSubview(present7Btn)
        view.addSubview(present8Btn)
        view.addSubview(present9Btn)
        view.addSubview(present10Btn)
        view.addSubview(presentNormalBtn)
        view.addSubview(picIV)
        
        popBtn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(topBar.snp.bottom).offset(30)
        }
        present1Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(popBtn.snp.bottom).offset(20)
        }
        present2Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present1Btn.snp.bottom).offset(20)
        }
        present3Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present2Btn.snp.bottom).offset(20)
        }
        present4Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present3Btn.snp.bottom).offset(20)
        }
        present5Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present4Btn.snp.bottom).offset(20)
        }
        present6Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present5Btn.snp.bottom).offset(20)
        }
        present7Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present6Btn.snp.bottom).offset(20)
        }
        present8Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present7Btn.snp.bottom).offset(20)
        }
        present9Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present8Btn.snp.bottom).offset(20)
        }
        present10Btn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present9Btn.snp.bottom).offset(20)
        }
        presentNormalBtn.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(present10Btn.snp.bottom).offset(20)
        }
        picIV.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100 * 872 / 658.0)
            make.leading.equalTo(10)
            make.top.equalTo(topBar.snp.bottom).offset(30)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func clickPopBtn(sender: UIButton) -> Void {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickPresent1Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type1
        vc.generic.presentAnimator()?.height = 300
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent2Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type2
        vc.generic.presentAnimator()?.height = 400
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent3Btn(sender: UIButton) -> Void {
        let vc = PicViewController()
        vc.generic.presentAnimator()?.type = .type3
        vc.generic.presentAnimator()?.fromView = picIV
        vc.generic.presentAnimator()?.toView = vc.iv
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent4Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type4
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent5Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type5
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent6Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type6
        vc.generic.presentAnimator()?.width = kScreenWidth - 100
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent7Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type7
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent8Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type8
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent9Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type9
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresent10Btn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .type10
        vc.generic.presentAnimator()?.width = 300
        self.generic.present(vc, animated: true)
    }
    
    @objc func clickPresentNorBtn(sender: UIButton) -> Void {
        let vc = MenuViewController()
        vc.generic.presentAnimator()?.type = .none
        vc.modalPresentationStyle = .fullScreen
        self.generic.present(vc, animated: true)
    }
}
