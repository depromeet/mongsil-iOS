//
//  DreamInfo.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/29.
//

import Foundation

public struct DreamInfo: Decodable {
  public let title: String
  public let description: String
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    title = try values.decode(String.self, forKey: .title)
    description = try values.decode(String.self, forKey: .description)
  }
  
  public enum CodingKeys: String, CodingKey {
    case title = "dream"
    case description = "translate"
  }
}
