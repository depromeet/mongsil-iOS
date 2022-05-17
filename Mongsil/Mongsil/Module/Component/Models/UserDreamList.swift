//
//  UserDreamList.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/17.
//

import Foundation

public struct UserDreamList: Codable, Equatable, Hashable {
  public let dreamList: [UserDream]

  public enum CodingKeys: String, CodingKey {
    case dreamList
  }

  public init(dreamList: [UserDream]) {
    self.dreamList = dreamList
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.dreamList = try container.decode([UserDream].self, forKey: .dreamList)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(dreamList, forKey: .dreamList)
  }
}
