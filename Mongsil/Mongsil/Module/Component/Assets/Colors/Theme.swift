//
//  Theme.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/10.
//

import SwiftUI

struct Theme {
  static func backgroundColor(scheme: ColorScheme) -> Color {
    let darkColor = Color.background

    switch scheme {
    case .light:
      return darkColor
    case .dark:
      return darkColor
    @unknown default:
      return darkColor
    }
  }
}
