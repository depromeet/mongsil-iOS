//
//  UIFont+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/10.
//

import UIKit

extension UIFont {
  public static func registerSharedFonts() {
    R.CustomFont.registerAllCustomFonts()
  }
}

extension UIFont {
  private static var regular = R.font.notoSansKRRegular.fontName
  private static var medium = R.font.notoSansKRMedium.fontName
  private static var bold = R.font.notoSansKRBold.fontName

  public static var largeTitle = UIFont(name: medium, size: 32)!
  public static var title1 = UIFont(name: medium, size: 25)!
  public static var title2 = UIFont(name: medium, size: 20)!
  public static var title3 = UIFont(name: medium, size: 19)!
  public static var headline = UIFont(name: medium, size: 16)!
  public static var button = UIFont(name: medium, size: 15)!

  public static var body = UIFont(name: regular, size: 16)!
  public static var subheadline = UIFont(name: regular, size: 14)!
  public static var caption1 = UIFont(name: regular, size: 13)!
  public static var caption2 = UIFont(name: regular, size: 12)!
  public static var caption3 = UIFont(name: regular, size: 10)!
}
