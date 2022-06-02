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
      return R.CustomImage.firstdOnboardingImage.image.resizable()

    case .second:
      return R.CustomImage.secondOnboardingImage.image.resizable()

    case .third:
      return R.CustomImage.thirdOnboardingImage.image.resizable()
    }
  }

  public var id: OnboardingImage {
    self
  }
}
