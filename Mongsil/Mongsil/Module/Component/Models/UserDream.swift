//
//  UserDream.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/10.
//

import Foundation

public struct UserDream: Codable, Equatable, Hashable {
  public let id: String
  public let dreamID: String
  public let registerDate: Date
  public let title: String
  public let description: String
  public let categories: [Category]

  public enum CodingKeys: String, CodingKey {
    case id, registerDate, title, description, categories
    case dreamID = "dreamId"
  }

  public init(
    id: String,
    dreamID: String,
    registerDate: Date,
    title: String,
    description: String,
    categories: [Category]
  ) {
    self.id = id
    self.dreamID = dreamID
    self.registerDate = registerDate
    self.title = title
    self.description = description
    self.categories = categories
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.dreamID = try container.decode(String.self, forKey: .dreamID)
    self.registerDate = try container.decode(Date.self, forKey: .registerDate)
    self.title = try container.decode(String.self, forKey: .title)
    self.description = try container.decode(String.self, forKey: .description)
    self.categories = try container.decode([Category].self, forKey: .categories)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    try container.encode(id, forKey: .id)
    try container.encode(dreamID, forKey: .dreamID)
    try container.encode(registerDate, forKey: .registerDate)
    try container.encode(title, forKey: .title)
    try container.encode(description, forKey: .description)
    try container.encode(categories, forKey: .categories)
  }
}

extension UserDream {
  public enum Stub {
    public static let userDream1 = UserDream(
      id: "1",
      dreamID: "1",
      registerDate: Date(),
      title: "호랑이한테 물리는 꿈",
      description: "정말로 호랑이한테 물릴 수 있으니 야생에 가면 안됩니다.",
      categories: [
        .Stub.category1,
        .Stub.category2
      ]
    )
    public static let userDream2 = UserDream(
      id: "2",
      dreamID: "2",
      registerDate: Date(),
      title: "호랑이를 죽이는 꿈",
      description: "직장이나 학교에서 큰 성취감을 얻을 수 있는 꿈입니다.",
      categories: [.Stub.category1]
    )
    public static let userDream3 = UserDream(
      id: "3",
      dreamID: "3",
      registerDate: Date(),
      title: "호랑이한테 잡혀가는 꿈",
      description: "호랑이한테 물려가도 정신만 차리면 사는것처럼 항상 정신을 챙겨야합니다.",
      categories: [.Stub.category1]
    )
    public static let userDream4 = UserDream(
      id: "4",
      dreamID: "4",
      registerDate: Date(),
      title: "사자를 죽이는 꿈",
      description: "라이언킹을 죽였으니 이제 당신이 야생의 주인입니다.",
      categories: [.Stub.category2]
    )
    public static let userDream5 = UserDream(
      id: "5",
      dreamID: "5",
      registerDate: Date(),
      title: "사자한테 물리는 꿈",
      description: "사자는 호랑이보다 약하니 조금 덜 조심해도 됩니다.",
      categories: [.Stub.category2]
    )
    public static let userDream6 = UserDream(
      id: "6",
      dreamID: "6",
      registerDate: Date(),
      title: "사자한테 잡혀가는 꿈",
      description: "사자한테 잡혀가면 호랑이와 달리 무리 생활을 하기에 그냥 죽은것입니다.",
      categories: [.Stub.category2]
    )
    public static let userDream7 = UserDream(
      id: "7",
      dreamID: "7",
      registerDate: Date(),
      title: "머리가 터지는 꿈",
      description: "머리가 너무 아픈일의 연속이 일어나게 됩니다.",
      categories: [.Stub.category3]
    )
    public static let userDream8 = UserDream(
      id: "8",
      dreamID: "8",
      registerDate: Date(),
      title: "머리를 자르는 꿈",
      description: "시험이나 승진에서 좌절하게 됩니다.",
      categories: [.Stub.category3]
    )
    public static let userDream9 = UserDream(
      id: "9",
      dreamID: "9",
      registerDate: Date(),
      title: "눈이 안보이는 꿈",
      description: "루테인을 많이 챙겨 드셔야 합니다.",
      categories: [.Stub.category4]
    )
    public static let userDream10 = UserDream(
      id: "10",
      dreamID: "10",
      registerDate: Date(),
      title: "눈이 떠지는 꿈",
      description: "못보던 세상을 볼 수 있는 선구안을 가지게 됩니다.",
      categories: [.Stub.category4]
    )
  }
}
