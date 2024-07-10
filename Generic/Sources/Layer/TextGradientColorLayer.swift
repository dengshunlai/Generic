//
//  TextGradientLayer.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/7/5.
//

import UIKit

open class TextGradientColorLayer: CAGradientLayer {
    
    public lazy var label = {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 1
        label.textAlignment = .center
        return label
    }()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialization()
    }
    
    public override init() {
        super.init()
        initialization()
    }
    
    public func initialization() {
        self.colors = [UIColor.generic.hexColor("EE9AE5").cgColor,
                       UIColor.generic.hexColor("5961F9").cgColor]
        self.startPoint = CGPointMake(0, 0.5)
        self.endPoint = CGPointMake(1, 0.5)
    }
    
    public func sizeToFit() {
        self.frame = CGRect(x: 0, y: 0, width: label.intrinsicContentSize.width, height: label.intrinsicContentSize.height)
    }
    
    public func setText(_ text: String) {
        label.text = text
        label.sizeToFit()
        self.mask = label.layer
        self.sizeToFit()
    }
    
    public func setColors(_ colors: [UIColor]) {
        self.colors = colors.map({ $0.cgColor })
    }
}
