//
//  Subcategory.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/29.
//

import Foundation

public struct Subcategory: Decodable, Equatable {
  public let subcategory: String
  public let dreamInfo: [DreamInfo]

  public init(
    subcategory: String,
    dreamInfo: [DreamInfo]
  ) {
    self.subcategory = subcategory
    self.dreamInfo = dreamInfo
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    subcategory = try container.decode(String.self, forKey: .subcategory)
    dreamInfo = try container.decode([DreamInfo].self, forKey: .dreamInfo)
  }

  public enum CodingKeys: String, CodingKey {
    case subcategory, dreamInfo
  }
}

extension Subcategory {
  public enum Stub {
    public static let subcategory1 = Subcategory(
      subcategory: "호랑이",
      dreamInfo: [
        DreamInfo.Stub.dreamInfo1,
        DreamInfo.Stub.dreamInfo2,
        DreamInfo.Stub.dreamInfo3,
        DreamInfo.Stub.dreamInfo4,
        DreamInfo.Stub.dreamInfo5,
        DreamInfo.Stub.dreamInfo6
      ]
    )
    public static let subcategory2 = Subcategory(
      subcategory: "사자",
      dreamInfo: [
        DreamInfo.Stub.dreamInfo4,
        DreamInfo.Stub.dreamInfo5,
        DreamInfo.Stub.dreamInfo6
      ]
    )
    public static let subcategory3 = Subcategory(
      subcategory: "머리",
      dreamInfo: [
        DreamInfo.Stub.dreamInfo7,
        DreamInfo.Stub.dreamInfo8
      ]
    )
    public static let subcategory4 = Subcategory(
      subcategory: "눈",
      dreamInfo: [
        DreamInfo.Stub.dreamInfo9,
        DreamInfo.Stub.dreamInfo10
      ]
    )
  }
}
