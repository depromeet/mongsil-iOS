//
//  Category.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/17.
//

import Foundation

public struct Category: Codable, Equatable, Hashable {
  public let categoryID: String
  public let name: String
  public let image: String

  public enum CodingKeys: String, CodingKey {
    case name, image
    case categoryID = "categoryId"
  }

  public init(
    categoryID: String,
    name: String,
    image: String
  ) {
    self.categoryID = categoryID
    self.name = name
    self.image = image
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.categoryID = try container.decode(String.self, forKey: .categoryID)
    self.name = try container.decode(String.self, forKey: .name)
    self.image = try container.decode(String.self, forKey: .image)
  }
}

extension Category {
  public enum Stub {
    public static let category1 = Category(
      categoryID: "1",
      name: "호랑이",
      image: "테스트"
    )
    public static let category2 = Category(
      categoryID: "2",
      name: "사자",
      image: "테스트"
    )
    public static let category3 = Category(
      categoryID: "3",
      name: "머리",
      image: "테스트"
    )
    public static let category4 = Category(
      categoryID: "4",
      name: "눈",
      image: "테스트"
    )
  }
}
