//
//  GetDiaryListRequestDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/06/08.
//

import Foundation

public struct GetDiaryListRequestDto: Encodable {
  public var userID: String

  enum CodingKeys: String, CodingKey {
    case userID = "userId"
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(userID, forKey: .userID)
  }
}
