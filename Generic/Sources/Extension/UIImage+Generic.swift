//
//  UIImage+Generic.swift
//  Generic
//
//  Created by 邓顺来1992 on 2024/12/5.
//

import UIKit

extension UIImage: GenericNameSpaceProtocol {}

public extension GenericNameSpace where T == UIImage {
    
    ///图片置灰处理
    func gray() -> UIImage? {
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        let width = obj.size.width
        let height = obj.size.height
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil,
                                width: Int(width),
                                height: Int(height),
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo)
        if let context = context {
            if let cgImg = obj.cgImage {
                context.draw(cgImg, in: CGRect.init(x:0, y:0, width: width, height: height))
                if let contextCGImg = context.makeImage() {
                    let grayImage = UIImage(cgImage: contextCGImg)
                    return grayImage
                }
            }
        }
        return nil
    }
}
