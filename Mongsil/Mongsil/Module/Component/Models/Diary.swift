//
//  Diary.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/10.
//

import Foundation

public struct Diary: Codable, Equatable, Hashable {
  public let id: String
  public let title: String
  public let description: String
  public let date: String
  public let categoryList: [Category]

  public enum CodingKeys: String, CodingKey {
    case id, title, description, images, keywords, categoryList
    case date = "registerDate"
  }

  public init(
    id: String,
    title: String,
    description: String,
    date: String,
    categoryList: [Category]
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.date = date
    self.categoryList = categoryList
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.title = try container.decode(String.self, forKey: .title)
    self.description = try container.decode(String.self, forKey: .description)
    self.date = try container.decode(String.self, forKey: .date)
    self.categoryList = try container.decode([Category].self, forKey: .categoryList)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(description, forKey: .description)
    try container.encode(date, forKey: .date)
    try container.encode(categoryList, forKey: .categoryList)
  }
}

extension Diary {
  public enum Stub {
    public static let diaryList = [
      diary1,
      diary2,
      diary3,
      diary4,
      diary5,
      diary6
    ]

    public static let diary1 = Diary(
      id: "1",
      title: "호랑이가 다리를 무는 꿈",
      description: "호랑이가 꿈에 나타나 다리를 물었다. 매우 아팠다.",
      date: convertDateToString(Date()),
      categoryList: [Category.Stub.category1, Category.Stub.category2]
    )
    public static let diary2 = Diary(
      id: "2",
      title: "돼지가 돈다발을 들고 오는 꿈",
      description: "돼지가 두발로 걸어서 돈다발을 손에 들고 나에게 주었다. 아무래도 좋은 꿈인것 같다.",
      date: convertDateToString(Date()),
      categoryList: [Category.Stub.category2]
    )
    public static let diary3 = Diary(
      id: "3",
      title: "귀신에게 쫓기는 꿈",
      description: "지하철을 타다가 귀신이 저 멀리서 날아오고 있었다. 무서웠지만 꾹 참고 도망쳤다.",
      date: convertDateToString(Date()),
      categoryList: [Category.Stub.category3]
    )
    public static let diary4 = Diary(
      id: "4",
      title: "다리가 잘리는 꿈",
      description: "공사현장 인부로 일을 하고 있었는데 전기톱을 쓰다가 지진이 나는 바람에 다리가 잘렸다.\n 피가 분수처럼 솟구쳤다.",
      date: convertDateToString(Date()),
      categoryList: [Category.Stub.category4]
    )
    public static let diary5 = Diary(
      id: "5",
      title: "로또에 당첨되는 꿈",
      description: "로또에 나혼자 당첨이 되었다. 기쁜 마음에 바로 농협으로 수령하고 달려가다가 깼다.",
      date: convertDateToString(Date()),
      categoryList: [Category.Stub.category4]
    )
    public static let diary6 = Diary(
      id: "6",
      title: "절벽에서 뛰어내리는 꿈",
      description: "아래는 파도가 무섭게 치는 바다가 보이고 나는 그 위에서 번지점프 하듯이 뛰어내렸다.",
      date: "2022.04.10",
      categoryList: [Category.Stub.category4]
    )
  }
}
