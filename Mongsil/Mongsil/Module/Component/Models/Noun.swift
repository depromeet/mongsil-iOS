//
//  Noun.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/13.
//

import Foundation

public struct Noun: Decodable, Equatable, Hashable {
  public let name: String
  public let image: String
  public let categories: [Category]

  public enum CodingKeys: String, CodingKey {
    case name
    case image
    case categories
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    image = try values.decode(String.self, forKey: .image)
    categories = try values.decode([Category].self, forKey: .categories)
  }

  public init(
    name: String,
    image: String,
    categories: [Category]
  ) {
    self.name = name
    self.image = image
    self.categories = categories
  }
}
