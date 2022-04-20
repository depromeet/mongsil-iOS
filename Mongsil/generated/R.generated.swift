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

  /// This `R.color` struct is generated, and contains static references to 15 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")
    /// Color `Background`.
    static let background = Rswift.ColorResource(bundle: R.hostingBundle, name: "Background")
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
    /// Color `MilleYellow`.
    static let milleYellow = Rswift.ColorResource(bundle: R.hostingBundle, name: "MilleYellow")
    /// Color `White`.
    static let white = Rswift.ColorResource(bundle: R.hostingBundle, name: "White")

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
    /// `UIColor(named: "MilleYellow", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func milleYellow(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.milleYellow, compatibleWith: traitCollection)
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
    /// `UIColor(named: "MilleYellow", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func milleYellow(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.milleYellow.name)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "White", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func white(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.white.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 3 files.
  struct file {
    /// Resource file `NotoSansKR-Bold.otf`.
    static let notoSansKRBoldOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "NotoSansKR-Bold", pathExtension: "otf")
    /// Resource file `NotoSansKR-Medium.otf`.
    static let notoSansKRMediumOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "NotoSansKR-Medium", pathExtension: "otf")
    /// Resource file `NotoSansKR-Regular.otf`.
    static let notoSansKRRegularOtf = Rswift.FileResource(bundle: R.hostingBundle, name: "NotoSansKR-Regular", pathExtension: "otf")

    /// `bundle.url(forResource: "NotoSansKR-Bold", withExtension: "otf")`
    static func notoSansKRBoldOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.notoSansKRBoldOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "NotoSansKR-Medium", withExtension: "otf")`
    static func notoSansKRMediumOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.notoSansKRMediumOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "NotoSansKR-Regular", withExtension: "otf")`
    static func notoSansKRRegularOtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.notoSansKRRegularOtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 3 fonts.
  struct font: Rswift.Validatable {
    /// Font `NotoSansKR-Bold`.
    static let notoSansKRBold = Rswift.FontResource(fontName: "NotoSansKR-Bold")
    /// Font `NotoSansKR-Medium`.
    static let notoSansKRMedium = Rswift.FontResource(fontName: "NotoSansKR-Medium")
    /// Font `NotoSansKR-Regular`.
    static let notoSansKRRegular = Rswift.FontResource(fontName: "NotoSansKR-Regular")

    /// `UIFont(name: "NotoSansKR-Bold", size: ...)`
    static func notoSansKRBold(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: notoSansKRBold, size: size)
    }

    /// `UIFont(name: "NotoSansKR-Medium", size: ...)`
    static func notoSansKRMedium(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: notoSansKRMedium, size: size)
    }

    /// `UIFont(name: "NotoSansKR-Regular", size: ...)`
    static func notoSansKRRegular(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: notoSansKRRegular, size: size)
    }

    static func validate() throws {
      if R.font.notoSansKRBold(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'NotoSansKR-Bold' could not be loaded, is 'NotoSansKR-Bold.otf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.notoSansKRMedium(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'NotoSansKR-Medium' could not be loaded, is 'NotoSansKR-Medium.otf' added to the UIAppFonts array in this targets Info.plist?") }
      if R.font.notoSansKRRegular(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'NotoSansKR-Regular' could not be loaded, is 'NotoSansKR-Regular.otf' added to the UIAppFonts array in this targets Info.plist?") }
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
