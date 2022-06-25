//
//  GetDiaryResponseDto.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/20.
//

import Foundation

public struct GetDiaryResponseDto: Decodable {
  public let cardList: [Diary]

  public enum CodingKeys: String, CodingKey {
    case cardList
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.cardList = try container.decode([Diary].self, forKey: .cardList)
  }
}
