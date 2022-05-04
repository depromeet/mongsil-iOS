//
//  Dream.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/27.
//

import Foundation

public struct Dream: Decodable {
  public let category: [String: [Subcategory]]
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    category = try values.decode([String: [Subcategory]].self, forKey: .category)
  }
  
  public enum CodingKeys: String, CodingKey {
    case category
  }
}
