//
//  DreamModel.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/27.
//
import Foundation

struct Dream: Codable {
  let category: Category
}

struct Category: Codable {
  let category: [String: [SubCategory]]
}

struct SubCategory: Codable {
  let subCategory: [String: [DreamInfo]]
}

struct DreamInfo: Codable {
  let title: String
  let description: String
  
  enum CodingKeys: String, CodingKey {
    case title = "dream"
    case description = "translate"
  }
}
