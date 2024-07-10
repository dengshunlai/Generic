//
//  UIView+Loading.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/6/3.
//

import UIKit

extension UIView: GenericNameSpaceProtocol {}

public extension GenericNameSpace where T: UIView {
    
    func showLoading(isDisableClick: Bool = true) {
        let indicator = self.indicatorView()
        indicator.starAnimation()
        if isDisableClick && obj.isUserInteractionEnabled {
            obj.isUserInteractionEnabled = false
            indicator.tag = 1
        }
        indicator.isHidden = false

        if let constrains = indicatorViewConstraints() {
            NSLayoutConstraint.deactivate(constrains)
        }
        var constrains: [NSLayoutConstraint]
        if obj.bounds.size.height <= 0 {
            constrains = [
                indicator.centerXAnchor.constraint(equalTo: obj.centerXAnchor),
                indicator.centerYAnchor.constraint(equalTo: obj.centerYAnchor),
            ]
        } else {
            constrains = [
                indicator.centerXAnchor.constraint(equalTo: obj.leadingAnchor, constant: obj.bounds.origin.x + obj.bounds.size.width / 2),
                indicator.centerYAnchor.constraint(equalTo: obj.topAnchor, constant: obj.bounds.origin.y + obj.bounds.size.height / 2),
            ]
        }
        NSLayoutConstraint.activate(constrains)
        setIndicatorViewConstraints(constraints: constrains)
    }
    
    func removeLoading() {
        let indicator = self.indicatorView()
        indicator.removeAnimation()
        if indicator.tag == 1 {
            obj.isUserInteractionEnabled = true
            indicator.tag = 0
        }
        indicator.isHidden = true
    }
}

private var indicatorViewKey: Void?
private var indicatorViewConstraintsKey: Void?

public extension GenericNameSpace where T: UIView {
    
    func indicatorView() -> ActivityIndicator {
        var view = objc_getAssociatedObject(obj, &indicatorViewKey) as? ActivityIndicator
        if view == nil {
            view = ActivityIndicator(style: .style_0)
            view?.translatesAutoresizingMaskIntoConstraints = false
            obj.addSubview(view!)
            view?.isHidden = true
            setIndicatorView(view: view!)
        }
        return view!
    }
    
    func setIndicatorView(view: ActivityIndicator) {
        objc_setAssociatedObject(obj, &indicatorViewKey, view, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func indicatorViewConstraints() -> [NSLayoutConstraint]? {
        let constraints = objc_getAssociatedObject(obj, &indicatorViewConstraintsKey) as? [NSLayoutConstraint]
        return constraints
    }
    
    func setIndicatorViewConstraints(constraints: [NSLayoutConstraint]) {
        objc_setAssociatedObject(obj, &indicatorViewConstraintsKey, constraints, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
