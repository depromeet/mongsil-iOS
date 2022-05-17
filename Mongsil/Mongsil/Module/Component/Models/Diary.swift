//
//  Diary.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/10.
//

import Foundation

public struct Diary: Decodable, Equatable, Hashable {
  public let title: String
  public let description: String
  public let date: String
  public var firstImageToString: String?
  public var secondImageToString: String?
  public var firstImageURL: URL?
  public var secondImageURL: URL?

  public enum CodingKeys: String, CodingKey {
    case title, description, date
    case firstImageToString, secondImageToString
    case firstImageURL, secondImageURL
  }

  public init(
    title: String,
    description: String,
    date: String,
    firstImageToString: String? = nil,
    secondImageToString: String? = nil,
    firstImageURL: URL? = nil,
    secondImageURL: URL? = nil
  ) {
    self.title = title
    self.description = description
    self.date = date
    self.firstImageToString = firstImageToString
    self.secondImageToString = secondImageToString
    self.firstImageURL = firstImageURL
    self.secondImageURL = secondImageURL
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.title = try container.decode(String.self, forKey: .title)
    self.description = try container.decode(String.self, forKey: .description)
    self.date = try container.decode(String.self, forKey: .date)
    self.firstImageToString = try container.decodeIfPresent(String.self, forKey: .firstImageToString)
    if let firstImageToString = firstImageToString,
       firstImageToString != "" {
      self.firstImageURL = try container.decode(URL.self, forKey: .firstImageURL)
    }
    self.secondImageToString = try container.decodeIfPresent(String.self, forKey: .secondImageToString)
    if let secondImageToString = secondImageToString,
       secondImageToString != "" {
      self.secondImageURL = try container.decode(URL.self, forKey: .secondImageURL)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(title, forKey: .title)
    try container.encode(description, forKey: .description)
    try container.encode(date, forKey: .date)
    try container.encode(date, forKey: .date)
    try container.encode(firstImageToString, forKey: .firstImageToString)
    try container.encode(secondImageToString, forKey: .secondImageToString)
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
      date: convertDateToString(Date())
    )
    public static let diary2 = Diary(
      title: "돼지가 돈다발을 들고 오는 꿈",
      description: "돼지가 두발로 걸어서 돈다발을 손에 들고 나에게 주었다.\n아무래도 좋은 꿈인것 같다.",
      date: convertDateToString(Date())
    )
    public static let diary3 = Diary(
      title: "귀신에게 쫓기는 꿈",
      description: "지하철을 타다가 귀신이 저 멀리서 날아오고 있었다. 무서웠지만 꾹 참고 도망쳤다.",
      date: convertDateToString(Date())
    )
    public static let diary4 = Diary(
      title: "다리가 잘리는 꿈",
      description: "공사현장 인부로 일을 하고 있었는데 전기톱을 쓰다가 지진이 나는 바람에 다리가 잘렸다.\n 피가 분수처럼 솟구쳤다.",
      date: convertDateToString(Date())
    )
    public static let diary5 = Diary(
      title: "로또에 당첨되는 꿈",
      description: "로또에 나혼자 당첨이 되었다. 기쁜 마음에 바로 농협으로 수령하고 달려가다가 깼다.",
      date: convertDateToString(Date())
    )
    public static let diary6 = Diary(
      title: "절벽에서 뛰어내리는 꿈",
      description: "아래는 파도가 무섭게 치는 바다가 보이고 나는 그 위에서 번지점프 하듯이 뛰어내렸다.",
      date: "2022.04.10"
    )
  }
}
