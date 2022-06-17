//
//  GetDreamSearchResultCountResponseDto.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/24.
//

import Foundation

public struct GetDreamSearchResultCountResponseDto: Decodable {
  public let count: Int

  public enum CodingKeys: String, CodingKey {
    case count = "count"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.count = try container.decode(Int.self, forKey: .count)
  }
}
