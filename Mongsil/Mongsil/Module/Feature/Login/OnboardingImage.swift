//
//  OnboardingImage.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/19.
//

import SwiftUI

public enum OnboardingImage: CaseIterable, Identifiable {
  case first
  case second
  case third

  var image: Image {
    switch self {
    case .first:
      return R.CustomImage.cancelIcon.image
    case .second:
      return R.CustomImage.settingIcon.image
    case .third:
      return R.CustomImage.searchIcon.image
    }
  }

  public var id: OnboardingImage {
    self
  }
}
