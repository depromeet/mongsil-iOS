//
//  Category.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/17.
//

import Foundation

public struct Category: Codable, Equatable, Hashable, Identifiable {
  public var id: String
  public let name: String
  public let image: String
  public let parentsKeyword: String

  public enum CodingKeys: String, CodingKey {
    case id
    case name
    case image
    case parentsKeyword
  }

  public init(
    id: String,
    name: String,
    image: String,
    parentsKeyword: String
  ) {
    self.id = id
    self.name = name
    self.image = image
    self.parentsKeyword = parentsKeyword
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.image = try container.decode(String.self, forKey: .image)
    self.parentsKeyword = try container.decode(String.self, forKey: .parentsKeyword)
  }
}

extension Category {
  public enum Stub {
    public static let category1 = Category(
      id: "1",
      name: "호랑이",
      image: "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png",
      parentsKeyword: "동물"
    )
    public static let category2 = Category(
      id: "2",
      name: "달아나다",
      image: "https://user-images.githubusercontent.com/72292617/169724245-232f119e-6312-41f3-9f63-98b4957a4ec4.png",
      parentsKeyword: "ㄷ"
    )
    public static let category3 = Category(
      id: "3",
      name: "머리",
      image: "https://user-images.githubusercontent.com/72292617/169724376-42db644d-3b92-4f9c-986d-0cced5c771f9.png",
      parentsKeyword: "ㅁ"
    )
    public static let category4 = Category(
      id: "4",
      name: "눈",
      image: "https://user-images.githubusercontent.com/72292617/169724421-9a17cde0-cfb2-4c98-be77-b4bbcfe9bde6.png",
      parentsKeyword: "ㄴ"
    )
  }
}
