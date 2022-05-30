//
//  String+extensions.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/30.
//

import SwiftUI

extension String {
  public func textToImage() -> UIImage? {
    let nsString = (self as NSString)
    let font = UIFont.systemFont(ofSize: 40)
    let stringAttributes = [NSAttributedString.Key.font: font]
    let imageSize = nsString.size(withAttributes: stringAttributes)

    UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
    UIColor.clear.set()
    UIRectFill(CGRect(origin: CGPoint(), size: imageSize))
    nsString.draw(at: CGPoint.zero, withAttributes: stringAttributes)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image ?? UIImage()
  }
}
