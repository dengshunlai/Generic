//
//  Generic.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/5.
//

import Foundation

/// Generic 名称空间
public struct GenericNameSpace<T> {
    var obj: T
    var clazz: T.Type = T.self
    static var clazz: T.Type {
        return T.self
    }
    
    init(obj: T) {
        self.obj = obj
    }
}

public protocol GenericNameSpaceProtocol {
    
}

public extension GenericNameSpaceProtocol {
    var generic: GenericNameSpace<Self> {
        get {
            return GenericNameSpace.init(obj: self)
        }
    }
    static var generic: GenericNameSpace<Self>.Type {
        get {
            return GenericNameSpace<Self>.self
        }
    }
}
