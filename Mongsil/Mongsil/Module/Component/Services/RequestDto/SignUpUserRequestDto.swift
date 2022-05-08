//
//  SignUpUserRequestDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Foundation

public struct SignUpUserRequestDto: Encodable {
  public var userEmail: String
  public var userName: String

  enum CodingKeys: String, CodingKey {
    case userEmail, userName
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(userEmail, forKey: .userEmail)
    try container.encode(userName, forKey: .userName)
  }
}
