//
//  CheckUserResponseDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Foundation

public struct CheckUserResponseDto: Decodable {
  public let checkValue: Bool
  public let userId: String?

  public enum CodingKeys: String, CodingKey {
    case checkValue, userId
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.checkValue = try container.decode(Bool.self, forKey: .checkValue)
    self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
  }
}
