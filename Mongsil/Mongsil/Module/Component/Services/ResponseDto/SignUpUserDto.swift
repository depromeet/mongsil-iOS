//
//  SignUpUserResponseDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Foundation

public struct SignUpUserResponseDto: Decodable {
  public let userId: Int

  public enum CodingKeys: String, CodingKey {
    case userId
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.userId = try container.decode(Int.self, forKey: .userId)
  }
}
