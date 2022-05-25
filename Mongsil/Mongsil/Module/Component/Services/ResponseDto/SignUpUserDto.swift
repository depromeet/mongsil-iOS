//
//  SignUpUserResponseDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

import Foundation

public struct SignUpUserResponseDto: Decodable {
  public let userID: String
  
  public enum CodingKeys: String, CodingKey {
    case userID
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.userID = try container.decode(String.self, forKey: .userID)
  }
}
