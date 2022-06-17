//
//  SaveDiaryResponseDto.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/20.
//

import Foundation

public struct SaveDiaryResponseDto: Decodable {
  public let diaryID: String

  public enum CodingKeys: String, CodingKey {
    case diaryID = "diaryId"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.diaryID = try container.decode(String.self, forKey: .diaryID)
  }
}
