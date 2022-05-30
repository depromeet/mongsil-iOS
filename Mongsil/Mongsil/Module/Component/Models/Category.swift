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
      image: "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png"
    )
    public static let category2 = Category(
      categoryID: "2",
      name: "달아나다",
      image: "https://user-images.githubusercontent.com/72292617/169724245-232f119e-6312-41f3-9f63-98b4957a4ec4.png"
    )
    public static let category3 = Category(
      categoryID: "3",
      name: "머리",
      image: "https://user-images.githubusercontent.com/72292617/169724376-42db644d-3b92-4f9c-986d-0cced5c771f9.png"
    )
    public static let category4 = Category(
      categoryID: "4",
      name: "눈",
      image: "https://user-images.githubusercontent.com/72292617/169724421-9a17cde0-cfb2-4c98-be77-b4bbcfe9bde6.png"
    )
  }
}
