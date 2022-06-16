//
//  DiaryList.swift
//  Mongsil
//
//  Created by 이승후 on 2022/06/16.
//

import SwiftUI

public struct DiaryList: Decodable, Equatable, Hashable {
  public let cardList: [Diary]

  public init(
    cardList: [Diary]
  ) {
    self.cardList = cardList
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.cardList = try container.decode([Diary].self, forKey: .cardList)
  }

  public enum CodingKeys: String, CodingKey {
    case cardList
  }
}
