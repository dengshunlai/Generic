//
//  IdentifierProtocol.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

public protocol IdentifierProtocol {
    
}

public extension IdentifierProtocol where Self: UITableViewCell {
    static func identifier(context: String = "") -> String {
        let identifier = "identifier_\(type(of: self))_\(context)"
        return identifier
    }
}

public extension IdentifierProtocol where Self: UICollectionViewCell {
    static func identifier(context: String = "") -> String {
        let identifier = "identifier_\(type(of: self))_\(context)"
        return identifier
    }
}

public extension IdentifierProtocol where Self: UITableViewHeaderFooterView {
    static func identifier(context: String = "") -> String {
        let identifier = "identifier_\(type(of: self))_\(context)"
        return identifier
    }
}

public extension IdentifierProtocol where Self: UICollectionReusableView {
    static func identifier(context: String = "") -> String {
        let identifier = "identifier_\(type(of: self))_\(context)"
        return identifier
    }
}
