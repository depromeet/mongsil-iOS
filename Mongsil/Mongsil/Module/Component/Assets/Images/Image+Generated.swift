//
//  Image+Generated.swift
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
  public enum CustomImage {
    public static let backIcon = ImageAsset(name: "BackIcon")
    public static let cancelIcon = ImageAsset(name: "CancelIcon")
    public static let checkIcon = ImageAsset(name: "CheckIcon")
    public static let searchIcon = ImageAsset(name: "SearchIcon")
    public static let settingIcon = ImageAsset(name: "SettingIcon")
    public static let arrowLeftIcon = ImageAsset(name: "ArrowLeftIcon")
    public static let arrowRightIcon = ImageAsset(name: "ArrowRightIcon")
    public static let shareIcon = ImageAsset(name: "ShareIcon")
    public static let saveIcon = ImageAsset(name: "SaveIcon")
    public static let deleteIcon = ImageAsset(name: "DeleteIcon")
    public static let plusIcon = ImageAsset(name: "PlusIcon")
    public static let bookmarkIcon = ImageAsset(name: "BookmarkIcon")
  }
}

public struct ImageAsset {
  public fileprivate(set) var name: String

  #if os(macOS)
  public typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  public typealias Image = UIImage
  #endif

  public var uiImage: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  public var image: SwiftUI.Image {
    return SwiftUI.Image(uiImage: uiImage)
  }
}

public extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
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
