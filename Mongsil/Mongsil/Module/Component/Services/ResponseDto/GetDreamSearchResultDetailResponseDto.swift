//
//  GetDreamSearchResultDetailResponseDto.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/23.
//

import Foundation

public struct GetDreamSearchResultDetailResponseDto: Decodable {
  public let searchResultDetail: Dream

  public enum CodingKeys: String, CodingKey {
    case searchResultDetail = "dream"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.searchResultDetail = try container.decode(Dream.self, forKey: .searchResultDetail)
  }
}
