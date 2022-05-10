//
//  Dream.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/27.
//

import Foundation

public struct Dream: Decodable, Equatable {
  public let category: String
  public let subcategory: [Subcategory]

  public init(
    category: String,
    subcategory: [Subcategory]
  ) {
    self.category = category
    self.subcategory = subcategory
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    category = try container.decode(String.self, forKey: .category)
    subcategory = try container.decode([Subcategory].self, forKey: .subscategory)
  }

  public enum CodingKeys: String, CodingKey {
    case category, subscategory
  }
}

extension Dream {
  public enum Stub {
    public static let dream1 = Dream(
      category: "동물",
      subcategory: [
        Subcategory.Stub.subcategory1,
        Subcategory.Stub.subcategory2
      ]
    )
    public static let dream2 = Dream(
      category: "신체",
      subcategory: [
        Subcategory.Stub.subcategory3,
        Subcategory.Stub.subcategory4
      ]
    )
  }
}
