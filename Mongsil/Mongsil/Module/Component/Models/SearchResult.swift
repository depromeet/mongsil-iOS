//
//  SearchResult.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/22.
//

import Foundation

public struct SearchResult: Decodable, Hashable, Identifiable {
  public let id: String
  public let title: String
  public let image: [String]

  public enum CodingKeys: String, CodingKey {
    case id
    case title
    case image
  }

  public init(
    id: String,
    title: String,
    image: [String]
  ) {
    self.id = id
    self.title = title
    self.image = image
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.image = try container.decode([String].self, forKey: .image)
  }
}
