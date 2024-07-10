//
//  Const.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/5/6.
//

import UIKit

public let kScreenWidth = UIScreen.main.bounds.size.width
public let kScreenHeight = UIScreen.main.bounds.size.height

public let SCREEN_WIDTH = UIScreen.main.bounds.size.width
public let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

public func printLog(_ items: Any..., separator: String = " ", terminator: String = "\n") -> Void {
    #if DEBUG
        print(items, separator: separator, terminator: terminator)
    #endif
}
