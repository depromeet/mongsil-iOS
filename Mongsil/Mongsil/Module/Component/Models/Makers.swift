//
//  Makers.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/24.
//

import SwiftUI

public struct Makers: Equatable, Hashable {
  public let name: String
  public let position: String
  public var firstImageStr: String
  public var secondImageStr: String
  public var firstImage: Image {
    Image(uiImage: firstImageStr.textToImage()!)
  }
  public var secondImage: Image {
    Image(uiImage: secondImageStr.textToImage()!)
  }
  public let makersURL: URL

  public init(
    name: String,
    position: String,
    firstImageStr: String,
    secondImageStr: String,
    makersURL: URL
  ) {
    self.name = name
    self.position = position
    self.firstImageStr = firstImageStr
    self.secondImageStr = secondImageStr
    self.makersURL = makersURL
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(position)
    hasher.combine(makersURL)
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
    firstImageStr: "💡",
    secondImageStr: "🐷",
    makersURL: URL(string: "https://github.com/jonghopark95")!
  )
  public static let makers2 = Makers(
    name: "이건웅",
    position: "Backend Developer",
    firstImageStr: "🔧",
    secondImageStr: "🐮",
    makersURL: URL(string: "https://github.com/homelala")!
  )
  public static let makers3 = Makers(
    name: "이석호",
    position: "Backend Developer",
    firstImageStr: "🔧",
    secondImageStr: "🐭",
    makersURL: URL(string: "https://github.com/rrgks6221")!
  )
  public static let makers4 = Makers(
    name: "조찬우",
    position: "iOS Developer",
    firstImageStr: "🍏",
    secondImageStr: "🐵",
    makersURL: URL(string: "https://github.com/GREENOVER")!
  )
  public static let makers5 = Makers(
    name: "이승후",
    position: "iOS Developer",
    firstImageStr: "🍏",
    secondImageStr: "🐭",
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers6 = Makers(
    name: "이영은",
    position: "iOS Developer",
    firstImageStr: "🍏",
    secondImageStr: "🐑",
    makersURL: URL(string: "https://github.com/Monsteel")!
  )
  public static let makers7 = Makers(
    name: "정진아",
    position: "Designer",
    firstImageStr: "🎨",
    secondImageStr: "🐔",
    makersURL: URL(string: "https://www.behance.net/hellojina")!
  )
  public static let makers8 = Makers(
    name: "김나영",
    position: "Designer",
    firstImageStr: "🎨",
    secondImageStr: "🐭",
    makersURL: URL(string: "https://github.com/MoSonLee")!
  )
  public static let makers9 = Makers(
    name: "이영희",
    position: "Designer",
    firstImageStr: "🎨",
    secondImageStr: "🐯",
    makersURL: URL(string: "https://www.behance.net/altns684700d5")!
  )
}
