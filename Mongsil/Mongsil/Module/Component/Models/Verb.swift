//
//  Verb.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/14.
//

import Foundation

public struct Verb: Decodable, Equatable, Hashable {
  public let name: String
  public let categories: [Category]

  public enum CodingKeys: String, CodingKey {
    case name
    case categories
  }

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    categories = try values.decode([Category].self, forKey: .categories)
  }

  public init(name: String, categories: [Category]) {
    self.name = name
    self.categories = categories
  }
}
