//
//  UserDream.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/10.
//

import Foundation

public struct UserDream: Codable, Equatable, Hashable {
  public let id: String
  public let dreamID: String
  public let registerDate: Date
  public let title: String
  public let description: String
  public let categoryList: [Category]

  public enum CodingKeys: String, CodingKey {
    case id, registerDate, title, description, categoryList
    case dreamID = "dreamId"
  }

  public init(
    id: String,
    dreamID: String,
    registerDate: Date,
    title: String,
    description: String,
    categoryList: [Category]
  ) {
    self.id = id
    self.dreamID = dreamID
    self.registerDate = registerDate
    self.title = title
    self.description = description
    self.categoryList = categoryList
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.dreamID = try container.decode(String.self, forKey: .dreamID)
    self.registerDate = try container.decode(Date.self, forKey: .registerDate)
    self.title = try container.decode(String.self, forKey: .title)
    self.description = try container.decode(String.self, forKey: .description)
    self.categoryList = try container.decode([Category].self, forKey: .categoryList)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(dreamID, forKey: .dreamID)
    try container.encode(registerDate, forKey: .registerDate)
    try container.encode(title, forKey: .title)
    try container.encode(description, forKey: .description)
    try container.encode(categoryList, forKey: .categoryList)
  }
}
