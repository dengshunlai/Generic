//
//  NavigationBar.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import UIKit

open class NavigationBar: UIView {
    open var backBtn: UIButton!
    open var titleLabel: UILabel!
    open var bottomLine: UIView!
    open weak var vc: UIViewController?
    open var onClickBack: (() -> Bool)?
    
    deinit {
        printLog("\(#function): \(type(of: self))")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialization()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.initialization()
    }
    
    public convenience init(title: String) {
        self.init(frame: CGRect.zero)
        titleLabel.text = title
    }
    
    func initialization() {
        backgroundColor = UIColor.white
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 3
        
        backBtn = UIButton.init(type: .custom)
        backBtn.setImage(UIImage.init(named: "back", in: Bundle(for: Self.self), compatibleWith: nil), for: .normal)
        backBtn.imageView?.contentMode = .scaleAspectFit
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backBtn)
        
        titleLabel = UILabel.init()
        titleLabel.textColor = UIColor.generic.hexColor("333333")
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        bottomLine = UIView.init()
        bottomLine.backgroundColor = UIColor.generic.hexColor("e4e4e4")
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomLine)
        
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            backBtn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            backBtn.widthAnchor.constraint(equalToConstant: 44 + 10),
            backBtn.heightAnchor.constraint(equalToConstant: 44),
        ])
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.bottomAnchor, constant: -44 / 2.0),
        ])
        NSLayoutConstraint.activate([
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        backBtn.addTarget(self, action: #selector(clickBackBtn(sender:)), for: .touchUpInside)
    }
    
    @objc func clickBackBtn(sender: UIButton) -> Void {
        if let block = onClickBack {
            let b = block()
            if b {
                vc?.navigationController?.popViewController(animated: true)
            }
        } else {
            vc?.navigationController?.popViewController(animated: true)
        }
    }
}
