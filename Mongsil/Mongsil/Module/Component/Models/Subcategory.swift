//
//  Subcategory.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/29.
//

import Foundation

public struct Subcategory: Decodable {
  public let subcategory: [String: [DreamInfo]]

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    subcategory = try values.decode([String: [DreamInfo]].self, forKey: .subcategory)
  }

  public enum CodingKeys: String, CodingKey {
    case subcategory
  }
}
