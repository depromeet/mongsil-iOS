//
//  HotKeyword.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/31.
//

import Foundation

public struct HotKeyword: Decodable {
  public let categories: [String]

  public enum CodingKeys: String, CodingKey {
    case categories
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    categories = try values.decode([String].self, forKey: .categories)
  }
}
