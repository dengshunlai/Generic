//
//  TextGradientVC.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/7/5.
//

import UIKit
import Generic

class TextGradientColorVC: ProjBaseViewController {
    
    lazy var layer1 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("EE9AE5").cgColor,
                        UIColor.generic.hexColor("5961F9").cgColor]
        return layer
    }()
    lazy var layer2 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("FFD3A5").cgColor,
                        UIColor.generic.hexColor("FD6585").cgColor]
        return layer
    }()
    lazy var layer3 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("C2FFD8").cgColor,
                        UIColor.generic.hexColor("465EFB").cgColor]
        return layer
    }()
    lazy var layer4 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("FD6585").cgColor,
                        UIColor.generic.hexColor("0D25B9").cgColor]
        return layer
    }()
    lazy var layer5 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("FD6E6A").cgColor,
                        UIColor.generic.hexColor("FFC600").cgColor]
        return layer
    }()
    lazy var layer6 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("65FDF0").cgColor,
                        UIColor.generic.hexColor("1D6FA3").cgColor]
        return layer
    }()
    lazy var layer7 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("6B73FF").cgColor,
                        UIColor.generic.hexColor("000DFF").cgColor]
        return layer
    }()
    lazy var layer8 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("FF7AF5").cgColor,
                        UIColor.generic.hexColor("513162").cgColor]
        return layer
    }()
    lazy var layer9 = {
        let layer = TextGradientColorLayer()
        layer.colors = [UIColor.generic.hexColor("F0FF00").cgColor,
                        UIColor.generic.hexColor("58CFFB").cgColor]
        return layer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        topBar.titleLabel.text = "文字渐变Label"
        
        view.layer.addSublayer(layer1)
        view.layer.addSublayer(layer2)
        view.layer.addSublayer(layer3)
        view.layer.addSublayer(layer4)
        view.layer.addSublayer(layer5)
        view.layer.addSublayer(layer6)
        view.layer.addSublayer(layer7)
        view.layer.addSublayer(layer8)
        view.layer.addSublayer(layer9)
        
        layer1.setText("深圳市福田区")
        layer2.setText("深圳市龙岗区")
        layer3.setText("深圳市南山区")
        layer4.setText("深圳市罗湖区")
        layer5.setText("深圳市龙华区")
        layer6.setText("深圳市光明区")
        layer7.setText("深圳市宝安区")
        layer8.setText("深圳市观澜区")
        layer9.setText("深圳市梅沙区")
        
        layer1.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 - 250)
        layer2.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 - 200)
        layer3.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 - 150)
        layer4.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 - 100)
        layer5.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 - 50)
        layer6.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 - 0)
        layer7.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 + 50)
        layer8.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 + 100)
        layer9.position = CGPoint(x: kScreenWidth / 2, y: kScreenHeight / 2 + 150)
    }
}
