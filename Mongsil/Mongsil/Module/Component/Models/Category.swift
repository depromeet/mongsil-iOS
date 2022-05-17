//
//  Category.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/17.
//

import Foundation

public struct Category: Codable, Equatable, Hashable {
  public let categoryID: String
  public let name: String
  public let image: String

  public enum CodingKeys: String, CodingKey {
    case name, image
    case categoryID = "categoryId"
  }

  public init(
    categoryID: String,
    name: String,
    image: String
  ) {
    self.categoryID = categoryID
    self.name = name
    self.image = image
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.categoryID = try container.decode(String.self, forKey: .categoryID)
    self.name = try container.decode(String.self, forKey: .name)
    self.image = try container.decode(String.self, forKey: .image)
  }
}
