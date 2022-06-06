//
//  Diary.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/10.
//

import Foundation

public struct Diary: Codable, Equatable, Hashable {
  public let title: String
  public let description: String
  public let date: String
  public var images: [String]
  public var keywords: [String]

  public enum CodingKeys: String, CodingKey {
    case title, description, date, images, keywords
  }

  public init(
    title: String,
    description: String,
    date: String,
    images: [String],
    keywords: [String]
  ) {
    self.title = title
    self.description = description
    self.date = date
    self.images = images
    self.keywords = keywords
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.title = try container.decode(String.self, forKey: .title)
    self.description = try container.decode(String.self, forKey: .description)
    self.date = try container.decode(String.self, forKey: .date)
    self.images = try container.decode([String].self, forKey: .images)
    self.keywords = try container.decode([String].self, forKey: .keywords)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(title, forKey: .title)
    try container.encode(description, forKey: .description)
    try container.encode(date, forKey: .date)
    try container.encode(images, forKey: .images)
    try container.encode(keywords, forKey: .keywords)
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
      title: "호랑이가 다리를 무는 꿈",
      description: "호랑이가 꿈에 나타나 다리를 물었다. 매우 아팠다.",
      date: convertDateToString(Date()),
      images: [
        "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png",
        "https://user-images.githubusercontent.com/72292617/169724245-232f119e-6312-41f3-9f63-98b4957a4ec4.png"
      ],
      keywords: ["호랑이", "달아나다"]
    )
    public static let diary2 = Diary(
      title: "돼지가 돈다발을 들고 오는 꿈",
      description: "돼지가 두발로 걸어서 돈다발을 손에 들고 나에게 주었다. 아무래도 좋은 꿈인것 같다.",
      date: convertDateToString(Date()),
      images: [
        "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png",
        "https://user-images.githubusercontent.com/72292617/169724245-232f119e-6312-41f3-9f63-98b4957a4ec4.png"
      ],
      keywords: ["돼지", "돈다발"]
    )
    public static let diary3 = Diary(
      title: "귀신에게 쫓기는 꿈",
      description: "지하철을 타다가 귀신이 저 멀리서 날아오고 있었다. 무서웠지만 꾹 참고 도망쳤다.",
      date: convertDateToString(Date()),
      images: [
        "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png",
        "https://user-images.githubusercontent.com/72292617/169724245-232f119e-6312-41f3-9f63-98b4957a4ec4.png"
      ],
      keywords: ["귀신", "쫓기다"]
    )
    public static let diary4 = Diary(
      title: "다리가 잘리는 꿈",
      description: "공사현장 인부로 일을 하고 있었는데 전기톱을 쓰다가 지진이 나는 바람에 다리가 잘렸다.\n 피가 분수처럼 솟구쳤다.",
      date: convertDateToString(Date()),
      images: [
        "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png",
        "https://user-images.githubusercontent.com/72292617/169724245-232f119e-6312-41f3-9f63-98b4957a4ec4.png"
      ],
      keywords: ["다리"]
    )
    public static let diary5 = Diary(
      title: "로또에 당첨되는 꿈",
      description: "로또에 나혼자 당첨이 되었다. 기쁜 마음에 바로 농협으로 수령하고 달려가다가 깼다.",
      date: convertDateToString(Date()),
      images: [
        "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png"
      ],
      keywords: ["로또"]
    )
    public static let diary6 = Diary(
      title: "절벽에서 뛰어내리는 꿈",
      description: "아래는 파도가 무섭게 치는 바다가 보이고 나는 그 위에서 번지점프 하듯이 뛰어내렸다.",
      date: "2022.04.10",
      images: [
        "https://user-images.githubusercontent.com/72292617/169724165-75c12342-83fb-4673-a2d9-460f9a14104d.png"
      ],
      keywords: ["절벽"]
    )
  }
}
