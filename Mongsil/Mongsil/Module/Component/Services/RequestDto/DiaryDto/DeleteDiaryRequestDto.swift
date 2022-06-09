//
//  DeleteDiaryRequestDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/06/08.
//

import Foundation

public struct DeleteDiaryRequestDto: Encodable {
  public var cardID: String

  enum CodingKeys: String, CodingKey {
    case cardID = "cardId"
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(cardID, forKey: .cardID)
  }
}
