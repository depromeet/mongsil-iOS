//
//  SaveDiaryRequestDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/06/08.
//

import Foundation

public struct SaveDiaryRequestDto: Encodable {
  public var userID: String
  public var title: String
  public var description: String
  public var categories: [String]

  enum CodingKeys: String, CodingKey {
    case userID = "userId"
    case title, description, categories
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(userID, forKey: .userID)
    try container.encode(title, forKey: .title)
    try container.encode(description, forKey: .description)
    try container.encode(categories, forKey: .categories)
  }
}
