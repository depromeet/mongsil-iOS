//
//  Subcategory.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/29.
//

import Foundation

struct Subcategory: Decodable {
  let subcategory: [String: [DreamInfo]]
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    subcategory = try values.decode([String: [DreamInfo]].self, forKey: .subcategory)
  }
  
  enum CodingKeys: String, CodingKey {
    case subcategory
  }
}
