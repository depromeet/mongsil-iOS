//
//  CheckUserResponseDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Foundation

public struct CheckUserResponseDto: Decodable {
  public let checkValue: Bool
  public let userID: String?

  public enum CodingKeys: String, CodingKey {
    case checkValue, userID
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.checkValue = try container.decode(Bool.self, forKey: .checkValue)
    self.userID = try container.decodeIfPresent(String.self, forKey: .userID)
  }
}
