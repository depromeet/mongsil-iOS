//
//  User.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/28.
//

import Foundation

public struct User: Decodable {
  public let name: String?
  public let email: String?

  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decodeIfPresent(String.self, forKey: .name)
    email = try values.decodeIfPresent(String.self, forKey: .email)
  }

  public enum CodingKeys: String, CodingKey {
    case name
    case email
  }
}
