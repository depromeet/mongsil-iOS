//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try font.validate()
    try intern.validate()
  }

  /// This `R.color` struct is generated, and contains static references to 18 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `Background`.
    static let background = Rswift.ColorResource(bundle: R.hostingBundle, name: "Background")
    /// Color `Blue`.
    static let blue = Rswift.ColorResource(bundle: R.hostingBundle, name: "Blue")
    /// Color `Gray10`.
    static let gray10 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray10")
    /// Color `Gray11`.
    static let gray11 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray11")
    /// Color `Gray1`.
    static let gray1 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray1")
    /// Color `Gray2`.
    static let gray2 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray2")
    /// Color `Gray3`.
    static let gray3 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray3")
    /// Color `Gray4`.
    static let gray4 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray4")
    /// Color `Gray5`.
    static let gray5 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray5")
    /// Color `Gray6`.
    static let gray6 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray6")
    /// Color `Gray7`.
    static let gray7 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray7")
    /// Color `Gray8`.
    static let gray8 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray8")
    /// Color `Gray9`.
    static let gray9 = Rswift.ColorResource(bundle: R.hostingBundle, name: "Gray9")
    /// Color `Green`.
    static let green = Rswift.ColorResource(bundle: R.hostingBundle, name: "Green")
    /// Color `Red`.
    static let red = Rswift.ColorResource(bundle: R.hostingBundle, name: "Red")
    /// Color `White`.
    static let white = Rswift.ColorResource(bundle: R.hostingBundle, name: "White")
    /// Color `Yellow`.
    static let yellow = Rswift.ColorResource(bundle: R.hostingBundle, name: "Yellow")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Background", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func background(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.background, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Blue", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func blue(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.blue, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray1", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray1(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray1, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray10", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray10(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray10, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray11", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray11(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray11, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray2", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray2(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray2, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray3", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray3(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray3, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray4", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray4(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray4, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray5", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray5(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray5, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray6", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray6(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray6, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray7", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray7(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray7, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray8", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray8(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray8, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Gray9", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func gray9(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.gray9, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Green", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func green(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.green, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Red", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func red(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.red, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "White", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func white(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.white, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "Yellow", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func yellow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.yellow, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Background", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func background(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.background.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Blue", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func blue(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.blue.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray1", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray1(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray1.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray10", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray10(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray10.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray11", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray11(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray11.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray2", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray2(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray2.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray3", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray3(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray3.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray4", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray4(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray4.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray5", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray5(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray5.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray6", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray6(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray6.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray7", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray7(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray7.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray8", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray8(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray8.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Gray9", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func gray9(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.gray9.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Green", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func green(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.green.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Red", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func red(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.red.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "White", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func white(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.white.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "Yellow", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func yellow(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.yellow.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 3 files.
  struct file {
    /// Resource file `Pretendard-Medium.ttf`.
    static let pretendardMediumTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Pretendard-Medium", pathExtension: "ttf")
    /// Resource file `Pretendard-Regular.ttf`.
    static let pretendardRegularTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Pretendard-Regular", pathExtension: "ttf")
    /// Resource file `Pretendard-SemiBold.ttf`.
    static let pretendardSemiBoldTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "Pretendard-SemiBold", pathExtension: "ttf")

    /// `bundle.url(forResource: "Pretendard-Medium", withExtension: "ttf")`
    static func pretendardMediumTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.pretendardMediumTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "Pretendard-Regular", withExtension: "ttf")`
    static func pretendardRegularTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.pretendardRegularTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "Pretendard-SemiBold", withExtension: "ttf")`
    static func pretendardSemiBoldTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.pretendardSemiBoldTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 3 fonts.
  struct font: Rswift.Validatable {
    /// Font `Pretendard-Medium`.
    static let pretendardMedium = Rswift.FontResource(fontName: "Pretendard-Medium")
    /// Font `Pretendard-Regular`.
    static let pretendardRegular = Rswift.FontResource(fontName: "Pretendard-Regular")
    /// Font `Pretendard-SemiBold`.
    static let pretendardSemiBold = Rswift.FontResource(fontName: "Pretendard-SemiBold")

    /// `UIFont(name: "Pretendard-Medium", size: ...)`
    static func pretendardMedium(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: pretendardMedium, size: size)
    }

    /// `UIFont(name: "Pretendard-Regular", size: ...)`
    static func pretendardRegular(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: pretendardRegular, size: size)
    }

    /// `UIFont(name: "Pretendard-SemiBold", size: ...)`
    static func pretendardSemiBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: pretendardSemiBold, size: size)
    }

    static func validate() throws {
      if R.font.pretendardMedium(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Pretendard-Medium' could not be loaded, is 'Pretendard-Medium.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.pretendardRegular(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Pretendard-Regular' could not be loaded, is 'Pretendard-Regular.ttf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.pretendardSemiBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'Pretendard-SemiBold' could not be loaded, is 'Pretendard-SemiBold.ttf' added to the UIAppFonts array in this targets Info.plist?") }
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 14 images.
  struct image {
    /// Image `AppleLoginButton`.
    static let appleLoginButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "AppleLoginButton")
    /// Image `ArrowLeftIcon`.
    static let arrowLeftIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "ArrowLeftIcon")
    /// Image `ArrowRightIcon`.
    static let arrowRightIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "ArrowRightIcon")
    /// Image `BackIcon`.
    static let backIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "BackIcon")
    /// Image `BookmarkIcon`.
    static let bookmarkIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "BookmarkIcon")
    /// Image `CancelIcon`.
    static let cancelIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "CancelIcon")
    /// Image `CheckIcon`.
    static let checkIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "CheckIcon")
    /// Image `DeleteIcon`.
    static let deleteIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "DeleteIcon")
    /// Image `KakaoLoginButton`.
    static let kakaoLoginButton = Rswift.ImageResource(bundle: R.hostingBundle, name: "KakaoLoginButton")
    /// Image `PlusIcon`.
    static let plusIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "PlusIcon")
    /// Image `SaveIcon`.
    static let saveIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "SaveIcon")
    /// Image `SearchIcon`.
    static let searchIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "SearchIcon")
    /// Image `SettingIcon`.
    static let settingIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "SettingIcon")
    /// Image `ShareIcon`.
    static let shareIcon = Rswift.ImageResource(bundle: R.hostingBundle, name: "ShareIcon")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "AppleLoginButton", bundle: ..., traitCollection: ...)`
    static func appleLoginButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.appleLoginButton, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ArrowLeftIcon", bundle: ..., traitCollection: ...)`
    static func arrowLeftIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrowLeftIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ArrowRightIcon", bundle: ..., traitCollection: ...)`
    static func arrowRightIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.arrowRightIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "BackIcon", bundle: ..., traitCollection: ...)`
    static func backIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.backIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "BookmarkIcon", bundle: ..., traitCollection: ...)`
    static func bookmarkIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.bookmarkIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "CancelIcon", bundle: ..., traitCollection: ...)`
    static func cancelIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.cancelIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "CheckIcon", bundle: ..., traitCollection: ...)`
    static func checkIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.checkIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "DeleteIcon", bundle: ..., traitCollection: ...)`
    static func deleteIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.deleteIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "KakaoLoginButton", bundle: ..., traitCollection: ...)`
    static func kakaoLoginButton(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.kakaoLoginButton, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "PlusIcon", bundle: ..., traitCollection: ...)`
    static func plusIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.plusIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "SaveIcon", bundle: ..., traitCollection: ...)`
    static func saveIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.saveIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "SearchIcon", bundle: ..., traitCollection: ...)`
    static func searchIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.searchIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "SettingIcon", bundle: ..., traitCollection: ...)`
    static func settingIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.settingIcon, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "ShareIcon", bundle: ..., traitCollection: ...)`
    static func shareIcon(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.shareIcon, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    struct uiApplicationSceneManifest {
      static let _key = "UIApplicationSceneManifest"
      static let uiApplicationSupportsMultipleScenes = false

      struct uiSceneConfigurations {
        static let _key = "UISceneConfigurations"

        struct uiWindowSceneSessionRoleApplication {
          struct defaultConfiguration {
            static let _key = "Default Configuration"
            static let uiSceneConfigurationName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneConfigurationName") ?? "Default Configuration"
            static let uiSceneDelegateClassName = infoPlistString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication", "Default Configuration"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate"

            fileprivate init() {}
          }

          fileprivate init() {}
        }

        fileprivate init() {}
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      // There are no resources to validate
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R {
  fileprivate init() {}
}
