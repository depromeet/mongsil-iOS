//
//  DreamInfo.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/29.
//

import Foundation

struct DreamInfo: Decodable {
  let title: String
  let description: String
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    title = try values.decode(String.self, forKey: .title)
    description = try values.decode(String.self, forKey: .description)
  }
  
  enum CodingKeys: String, CodingKey {
    case title = "dream"
    case description = "translate"
  }
}
