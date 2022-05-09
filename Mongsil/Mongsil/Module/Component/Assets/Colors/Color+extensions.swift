//
//  Color+extensions.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/10.
//

import SwiftUI
import UIKit

// MARK: - Convenience Initializers

extension Color {
  public init(red: Int, green: Int, blue: Int) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")

    self.init(
      red: Double(red) / 255.0,
      green: Double(green) / 255.0,
      blue: Double(blue) / 255.0
    )
  }

  public init(hex: Int) {
    self.init(
      red: (hex >> 16) & 0xFF,
      green: (hex >> 8) & 0xFF,
      blue: hex & 0xFF
    )
  }
}

// MARK: - Colors

extension Color {
  public static var background: Color { Color(UIColor.background) }

  public static var gray1: Color { Color(UIColor.gray1) }
  public static var gray2: Color { Color(UIColor.gray2) }
  public static var gray3: Color { Color(UIColor.gray3) }
  public static var gray4: Color { Color(UIColor.gray4) }
  public static var gray5: Color { Color(UIColor.gray5) }
  public static var gray6: Color { Color(UIColor.gray6) }
  public static var gray7: Color { Color(UIColor.gray7) }
  public static var gray8: Color { Color(UIColor.gray8) }
  public static var gray9: Color { Color(UIColor.gray9) }
  public static var gray10: Color { Color(UIColor.gray10) }
  public static var gray11: Color { Color(UIColor.gray11) }

  public static var msBlue: Color { Color(UIColor.msBlue) }
  public static var msGreen: Color { Color(UIColor.msGreen) }
  public static var msRed: Color { Color(UIColor.msRed) }
  public static var msWhite: Color { Color(UIColor.msWhite) }
  public static var msYellow: Color { Color(UIColor.msYellow) }
  public static var msTabBar: Color { Color(UIColor.msTabBar) }
}

// MARK: - Helpers

extension Color {
  public var uiColor: UIColor? {
    return self.cgColor.flatMap(UIColor.init)
  }
}
