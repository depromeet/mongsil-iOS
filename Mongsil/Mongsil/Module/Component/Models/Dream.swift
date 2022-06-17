//
//  Dream.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/27.
//

import Foundation

public struct Dream: Decodable, Equatable {
  public let id: String
  public let title: String
  public let description: String
  public let categories: [Category]
  public let image: [String]

  public init(
    id: String,
    title: String,
    description: String,
    categories: [Category],
    image: [String]
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.categories = categories
    self.image = image
  }

  public enum CodingKeys: String, CodingKey {
    case id
    case title
    case description
    case categories
    case image
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.description = try container.decode(String.self, forKey: .description)
    self.categories = try container.decode([Category].self, forKey: .categories)
    self.image = try container.decode([String].self, forKey: .image)
  }
}
