//
//  UserDreamListIDRequestDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/17.
//

import Foundation

public struct UserDreamListIDRequestDto: Encodable {
  public var dreamIDList: [String]

  enum CodingKeys: String, CodingKey {
    case dreamIDList = "dreamIdList"
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(dreamIDList, forKey: .dreamIDList)
  }
}
