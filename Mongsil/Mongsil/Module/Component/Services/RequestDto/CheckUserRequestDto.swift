//
//  CheckUserRequestDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Foundation

public struct CheckUserRequestDto: Encodable {
  public var userEmail: String

  enum CodingKeys: String, CodingKey {
    case userEmail
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(userEmail, forKey: .userEmail)
  }
}
