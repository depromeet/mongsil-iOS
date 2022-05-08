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
  private static var regular = R.font.pretendardRegular.fontName
  private static var medium = R.font.pretendardMedium.fontName
  private static var semiBold = R.font.pretendardSemiBold.fontName
  private static var light = R.font.pretendardLight.fontName

  public static var largeTitle = UIFont(name: semiBold, size: 32)!
  public static var title1 = UIFont(name: light, size: 28)!
  public static var title2 = UIFont(name: semiBold, size: 22)!
  public static var title3 = UIFont(name: medium, size: 20)!
  public static var subTitle = UIFont(name: semiBold, size: 16)!
  public static var body = UIFont(name: regular, size: 16)!
  public static var body2 = UIFont(name: regular, size: 15)!
  public static var button = UIFont(name: medium, size: 15)!
  public static var caption1 = UIFont(name: regular, size: 13)!
  public static var caption2 = UIFont(name: regular, size: 12)!
}
