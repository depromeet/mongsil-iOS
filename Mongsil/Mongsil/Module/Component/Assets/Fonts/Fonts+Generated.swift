//
//  Fonts+Generated.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/10.
//

#if os(macOS)
import AppKit.NSFont
#elseif os(iOS) || os(tvOS) || os(watchOS)
import UIKit.UIFont
#endif

// MARK: - Fonts

extension R {
  public enum CustomFont {
    public enum Pretendard {
      public static let regular = FontConvertible(name: "Pretendard-Regular", family: "Pretendard", path: "Pretendard-Regular.ttf")
      public static let medium = FontConvertible(name: "Pretendard-Medium", family: "Pretendard", path: "Pretendard-Medium.ttf")
      public static let semiBold = FontConvertible(name: "Pretendard-SemiBold", family: "Pretendard", path: "Pretendard-SemiBold.ttf")
      public static let light = FontConvertible(name: "Pretendard-Light", family: "Pretendard", path: "Pretendard-Light.ttf")
      public static let all: [FontConvertible] = [regular, medium, semiBold]
    }
    public static let allCustomFonts: [FontConvertible] = [Pretendard.all].flatMap { $0 }
    public static func registerAllCustomFonts() {
      allCustomFonts.forEach { $0.register() }
    }
  }
}

// MARK: - Implementation Details

public struct FontConvertible {
  public let name: String
  public let family: String
  public let path: String

  #if os(macOS)
  public typealias Font = NSFont
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Font = UIFont
  #endif

  public func font(size: CGFloat) -> Font {
    guard let font = Font(font: self, size: size) else {
      fatalError("Unable to initialize font '\(name)' (\(family))")
    }
    return font
  }

  public func register() {
    guard let url = url else { return }
    CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
  }

  fileprivate var url: URL? {
    return BundleToken.bundle.url(forResource: path, withExtension: nil)
  }
}

public extension FontConvertible.Font {
  convenience init?(font: FontConvertible, size: CGFloat) {
    #if os(iOS) || os(tvOS) || os(watchOS)
    if !UIFont.fontNames(forFamilyName: font.family).contains(font.name) {
      font.register()
    }
    #elseif os(macOS)
    if let url = font.url, CTFontManagerGetScopeForURL(url as CFURL) == .none {
      font.register()
    }
    #endif

    self.init(name: font.name, size: size)
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
