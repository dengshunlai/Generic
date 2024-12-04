//
//  UIView+Message.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/2.
//

import UIKit

public extension GenericNameSpace where T: UIView {
    
    func showMessage(image: UIImage? = nil,
                     message: String? = nil,
                     subMessage: String? = nil,
                     buttonText: String? = nil,
                     buttonClickBlock: ((MessageView)->Void)? = nil,
                     yOffset: Double = 0) {
        let msgView = msgView()
        msgView.setMessage(image: image, 
                           text: message,
                           subText: subMessage,
                           btnText: buttonText,
                           buttonClickBlock: buttonClickBlock)
        obj.addSubview(msgView)
        msgView.isHidden = false
        
        if let constrains = msgView.thisConstraints {
            NSLayoutConstraint.deactivate(constrains)
        }
        var constrains: [NSLayoutConstraint]
        if obj.bounds.size.height <= 0 {
            constrains = [
                msgView.centerXAnchor.constraint(equalTo: obj.centerXAnchor),
                msgView.centerYAnchor.constraint(equalTo: obj.centerYAnchor, constant: yOffset),
            ]
        } else {
            constrains = [
                msgView.centerXAnchor.constraint(equalTo: obj.leadingAnchor, constant: obj.bounds.origin.x + obj.bounds.size.width / 2),
                msgView.centerYAnchor.constraint(equalTo: obj.topAnchor, constant: obj.bounds.origin.y + obj.bounds.size.height / 2 + yOffset),
            ]
        }
        NSLayoutConstraint.activate(constrains)
        msgView.thisConstraints = constrains
    }
    
    func removeMessage() {
        let msgView = msgView()
        msgView.isHidden = true
    }
}

private var msgViewKey: Void?

public extension GenericNameSpace where T: UIView {
    
    func msgView() -> MessageView {
        var view = objc_getAssociatedObject(obj, &msgViewKey) as? MessageView
        if view == nil {
            view = MessageView()
            view?.backgroundColor = UIColor.clear
            view?.translatesAutoresizingMaskIntoConstraints = false
            obj.addSubview(view!)
            view?.isHidden = true
            setMsgView(view: view!)
        }
        return view!
    }
    
    func setMsgView(view: MessageView) {
        objc_setAssociatedObject(obj, &msgViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

public class MessageView: BaseView {
    
    var thisConstraints: [NSLayoutConstraint]?
    var buttonClickBlock: ((MessageView)->Void)?
    
    lazy var icon = {
        let iv = UIImageView.init()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var textLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("666666")
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var subTextLabel = {
        let label = UILabel.init()
        label.textColor = UIColor.generic.hexColor("999999")
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    lazy var btn = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .white
        btn.setTitleColor(UIColor.generic.hexColor("666666"), for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.generic.hexColor("666666").cgColor
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(clickButton(sender:)), for: .touchUpInside)
        return btn
    }()
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(image: UIImage? = nil,
                     text: String? = nil,
                     subText: String? = nil,
                     btnText: String? = nil,
                     buttonClickBlock: ((MessageView)->Void)? = nil) {
        super.init(frame: .zero)
        setMessage(image: image,
                   text: text,
                   subText: subText,
                   btnText: btnText,
                   buttonClickBlock: buttonClickBlock)
    }
    
    public override func setupUI() {
        self.backgroundColor = .clear
        addSubview(icon)
        addSubview(textLabel)
        addSubview(subTextLabel)
        addSubview(btn)
    }
    
    public func setMessage(image: UIImage? = nil,
                           text: String? = nil,
                           subText: String? = nil,
                           btnText: String? = nil,
                           buttonClickBlock: ((MessageView)->Void)? = nil) {
        self.buttonClickBlock = buttonClickBlock
        if let image = image {
            icon.image = image
            icon.isHidden = false
        } else {
            icon.isHidden = true
        }
        if let text = text, text.count > 0 {
            textLabel.text = text
            textLabel.isHidden = false
        } else {
            textLabel.isHidden = true
        }
        if let subText = subText, subText.count > 0 {
            subTextLabel.text = subText
            subTextLabel.isHidden = false
        } else {
            subTextLabel.isHidden = true
        }
        if let btnText = btnText, btnText.count > 0 {
            btn.setTitle(btnText, for: .normal)
            btn.isHidden = false
        } else {
            btn.isHidden = true
        }
        updateAllConstrants()
    }
    
    func updateAllConstrants() {
        self.removeConstraints(self.constraints)
        icon.removeConstraints(icon.constraints)
        textLabel.removeConstraints(icon.constraints)
        subTextLabel.removeConstraints(icon.constraints)
        btn.removeConstraints(icon.constraints)
        
        var preView: UIView?
        if !icon.isHidden {
            NSLayoutConstraint.activate([
                icon.topAnchor.constraint(equalTo: self.topAnchor),
                icon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                icon.widthAnchor.constraint(equalToConstant: icon.image?.size.width ?? 0.0),
                icon.heightAnchor.constraint(equalToConstant: icon.image?.size.height ?? 0.0),
                icon.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                icon.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
            ])
            preView = icon
        }
        if !textLabel.isHidden {
            if let preView = preView {
                NSLayoutConstraint.activate([
                    textLabel.topAnchor.constraint(equalTo: preView.bottomAnchor, constant: 8),
                    textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    textLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    textLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    textLabel.topAnchor.constraint(equalTo: self.topAnchor),
                    textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    textLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    textLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                ])
            }
            preView = textLabel
        }
        if !subTextLabel.isHidden {
            if let preView = preView {
                NSLayoutConstraint.activate([
                    subTextLabel.topAnchor.constraint(equalTo: preView.bottomAnchor, constant: 8),
                    subTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    subTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    subTextLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    subTextLabel.topAnchor.constraint(equalTo: self.topAnchor),
                    subTextLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    subTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    subTextLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                ])
            }
            preView = subTextLabel
        }
        if !btn.isHidden {
            if let preView = preView {
                NSLayoutConstraint.activate([
                    btn.topAnchor.constraint(equalTo: preView.bottomAnchor, constant: 8),
                    btn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    btn.heightAnchor.constraint(equalToConstant: 30),
                    btn.widthAnchor.constraint(equalToConstant: btn.intrinsicContentSize.width + 12),
                    btn.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    btn.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                ])
            } else {
                NSLayoutConstraint.activate([
                    btn.topAnchor.constraint(equalTo: self.topAnchor),
                    btn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    btn.heightAnchor.constraint(equalToConstant: 30),
                    btn.widthAnchor.constraint(equalToConstant: btn.intrinsicContentSize.width + 8),
                    btn.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
                    btn.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor),
                ])
            }
            preView = btn
        }
    }
    
    @objc func clickButton(sender: UIButton) {
        self.buttonClickBlock?(self)
    }
}
