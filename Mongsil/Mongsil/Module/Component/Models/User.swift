//
//  User.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/28.
//
import Foundation

struct User: Decodable {
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    name = try values.decode(String.self, forKey: .name)
    email = try values.decode(String.self, forKey: .email)
  }
  
  let name: String?
  let email: String?
  
  enum CodingKeys: String, CodingKey {
    case name
    case email
  }
}

