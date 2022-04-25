//
//  Colors+Generated.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/10.
//

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#elseif os(tvOS) || os(watchOS)
import UIKit
#endif

import SwiftUI

extension R {
  public enum CustomColor {
    public static let background = ColorAsset(name: "Background")
    public static let gray1 = ColorAsset(name: "Gray1")
    public static let gray2 = ColorAsset(name: "Gray2")
    public static let gray3 = ColorAsset(name: "Gray3")
    public static let gray4 = ColorAsset(name: "Gray4")
    public static let gray5 = ColorAsset(name: "Gray5")
    public static let gray6 = ColorAsset(name: "Gray6")
    public static let gray7 = ColorAsset(name: "Gray7")
    public static let gray8 = ColorAsset(name: "Gray8")
    public static let gray9 = ColorAsset(name: "Gray9")
    public static let gray10 = ColorAsset(name: "Gray10")
    public static let gray11 = ColorAsset(name: "Gray11")
    public static let msBlue = ColorAsset(name: "MSBlue")
    public static let msGreen = ColorAsset(name: "MSGreen")
    public static let msRed = ColorAsset(name: "MSRed")
    public static let msWhite = ColorAsset(name: "MSWhite")
    public static let msYellow = ColorAsset(name: "MSYellow")
  }
}

public final class ColorAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Color = NSColor
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Color = UIColor
  #endif

  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  public private(set) lazy var uiColor: Color = {
    guard let color = Color(asset: self) else {
      fatalError("Unable to load color asset named \(name).")
    }
    return color
  }()

  public private(set) lazy var color: SwiftUI.Color = {
    return SwiftUI.Color(uiColor)
  }()

  fileprivate init(name: String) {
    self.name = name
  }
}

public extension ColorAsset.Color {
  @available(iOS 11.0, tvOS 11.0, watchOS 4.0, macOS 10.13, *)
  convenience init?(asset: ColorAsset) {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSColor.Name(asset.name), bundle: bundle)
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
