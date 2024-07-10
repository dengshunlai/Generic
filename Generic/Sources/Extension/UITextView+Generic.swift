//
//  UITextView+Placeholder.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/7/6.
//

import UIKit

public extension GenericNameSpace where T: UITextView {
    
    func setPlaceholder(_ text: String) {
        let label = placeholderLabel()
        label.text = text
        let observer = placeholderObserver()
        observer.removeNotification()
        observer.setupNotification()
    }
}

private var placeholderLabelKey: Void?
private var placeholderObserverKey: Void?
private var maxLengthNumKey: Void?

public extension GenericNameSpace where T: UITextView {
    
    func placeholderLabel() -> UILabel {
        var label = objc_getAssociatedObject(obj, &placeholderLabelKey) as? UILabel
        if label == nil {
            label = UILabel()
            label?.textColor = UIColor.generic.hexColor("999999")
            label?.font = UIFont.systemFont(ofSize: 12)
            label?.numberOfLines = 1
            label?.textAlignment = .left
            label?.translatesAutoresizingMaskIntoConstraints = false
            setPlaceholderLabel(label: label!)
        }
        if let label = label, let aClass = NSClassFromString("_UITextContainerView") {
            var textContainerView: UIView?
            for view in obj.subviews {
                if view.isKind(of: aClass) {
                    textContainerView = view
                }
            }
            if let textContainerView = textContainerView {
                textContainerView.addSubview(label)
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: textContainerView.leadingAnchor, constant: 5),
                    label.trailingAnchor.constraint(greaterThanOrEqualTo: textContainerView.trailingAnchor, constant: -5),
                    label.topAnchor.constraint(equalTo: textContainerView.topAnchor, constant: 0),
                    label.bottomAnchor.constraint(equalTo: textContainerView.bottomAnchor, constant: 0),
                ])
            }
        }
        return label!
    }
    
    func placeholderObserver() -> TextViewPlaceholderObserver {
        var observer = objc_getAssociatedObject(obj, &placeholderObserverKey) as? TextViewPlaceholderObserver
        if observer == nil {
            observer = TextViewPlaceholderObserver()
            observer?.textView = obj
            setPlaceholderObserver(observer: observer!)
        }
        return observer!
    }
    
    func maxLength() -> Int {
        var length = objc_getAssociatedObject(obj, &maxLengthNumKey) as? Int
        if length == nil {
            length = 0
            setMaxLength(length: length!)
        }
        return length!
    }
    
    func setPlaceholderLabel(label: UILabel) {
        objc_setAssociatedObject(obj, &placeholderLabelKey, label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func setPlaceholderObserver(observer: TextViewPlaceholderObserver) {
        objc_setAssociatedObject(obj, &placeholderObserverKey, observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func setMaxLength(length: Int) {
        objc_setAssociatedObject(obj, &maxLengthNumKey, length, .OBJC_ASSOCIATION_ASSIGN)
    }
}


open class TextViewPlaceholderObserver: NSObject {
    
    weak var textView: UITextView?
    
    deinit {
        removeNotification()
    }
    
    func setupNotification() {
        if let textView = textView {
            NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange), name: UITextView.textDidChangeNotification, object: textView)
        }
    }
    
    func removeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textViewTextDidChange() {
        guard let textView = textView else {
            return
        }
        let label = textView.generic.placeholderLabel()
        if textView.text.count > 0 {
            label.isHidden = true
        } else {
            label.isHidden = false
        }
        let maxLength = textView.generic.maxLength()
        if maxLength > 0 {
            if textView.text.count > maxLength {
                textView.text = String(textView.text.prefix(maxLength))
            }
        }
    }
}
