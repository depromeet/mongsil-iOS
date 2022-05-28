//
//  Makers.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/24.
//

import Foundation
import SwiftUI

public struct Makers: Equatable, Hashable {
  public let name: String
  public let position: String
  public let firstImageStr: String = ""
  public let secondImageStr: String = ""
  public var firstImage: Image {
    stringToImage(firstImageStr)
  }
  public var secondImage: Image {
    stringToImage(secondImageStr)
  }
  public let makersURL: URL

  public init(
    name: String,
    position: String,
    firstImage: Image,
    secondImage: Image,
    firstImageToString: String? = nil,
    secondImageToString: String? = nil,
    makersURL: URL
  ) {
    self.name = name
    self.position = position
    self.makersURL = makersURL
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(position)
    hasher.combine(makersURL)
  }

  public func stringToImage(_ imageName: String) -> Image {
    return Image(systemName: imageName)
  }
}

extension Makers {
  public static let makersList = [
    makers1,
    makers2,
    makers3,
    makers4,
    makers5,
    makers6,
    makers7,
    makers8,
    makers9
  ]

  public static let makers1 = Makers(
    name: "박종호",
    position: "PM",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers2 = Makers(
    name: "이건웅",
    position: "Backend Developer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/depromeet/mongsil-iOS")!
  )
  public static let makers3 = Makers(
    name: "이석호",
    position: "Backend Developer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers4 = Makers(
    name: "조찬우",
    position: "iOS Developer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers5 = Makers(
    name: "이승후",
    position: "iOS Developer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers6 = Makers(
    name: "이영은",
    position: "iOS Developer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers7 = Makers(
    name: "정진아",
    position: "Designer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers8 = Makers(
    name: "김나영",
    position: "Designer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers9 = Makers(
    name: "이영희",
    position: "Designer",
    firstImage: R.CustomImage.homeActiveIcon.image,
    secondImage: R.CustomImage.homeDisabledIcon.image,
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
}
