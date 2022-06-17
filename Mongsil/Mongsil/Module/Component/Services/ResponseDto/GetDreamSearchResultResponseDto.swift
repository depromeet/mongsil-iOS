//
//  GetDreamSearchResultResponseDto.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/22.
//

import Foundation

public struct GetDreamSearchResultResponseDto: Decodable {
  public let searchResult: [SearchResult]

  public enum CodingKeys: String, CodingKey {
    case searchResult = "dream"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.searchResult = try container.decode([SearchResult].self, forKey: .searchResult)
  }
}
