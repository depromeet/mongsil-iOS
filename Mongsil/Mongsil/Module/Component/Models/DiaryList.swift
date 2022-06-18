//
//  DiaryList.swift
//  Mongsil
//
//  Created by 이승후 on 2022/06/16.
//

import Foundation

public struct DiaryList: Decodable {
  public let cardList: [Diary]

  public enum CodingKeys: String, CodingKey {
    case cardList
  }

  public init(
    cardList: [Diary]
  ) {
    self.cardList = cardList
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.cardList = try container.decode([Diary].self, forKey: .cardList)
  }
}
