//
//  SaveDreamRequestDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/17.
//

import Foundation

public struct SaveDreamRequestDto: Encodable {
  public var userID: String
  public var dreamID: String

  enum CodingKeys: String, CodingKey {
    case userID = "userID"
    case dreamID = "dreamId"
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(userID, forKey: .userID)
    try container.encode(dreamID, forKey: .dreamID)
  }
}
