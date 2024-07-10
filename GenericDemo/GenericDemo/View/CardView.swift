//
//  CardView.swift
//  GenericDemo
//
//  Created by 邓顺来1992 on 2024/7/7.
//

import UIKit
import Generic

class CardView: BaseView {
    
    lazy var iv = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        addSubview(iv)
        
        iv.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func fillView(index: Int) {
        let idx = index % 6
        iv.image = UIImage(named: "animal_\(idx + 1)")
    }
}
