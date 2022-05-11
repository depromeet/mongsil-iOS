//
//  DreamInfo.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/29.
//

import Foundation

public struct DreamInfo: Decodable, Equatable, Hashable {
  public let title: String
  public let description: String

  public init(
    title: String,
    description: String
  ) {
    self.title = title
    self.description = description
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    title = try container.decode(String.self, forKey: .title)
    description = try container.decode(String.self, forKey: .description)
  }

  public enum CodingKeys: String, CodingKey {
    case title = "dream"
    case description = "translate"
  }
}

extension DreamInfo {
  public enum Stub {
    public static let dreamInfo1 = DreamInfo(
      title: "호랑이한테 물리는 꿈",
      description: "정말로 호랑이한테 물릴 수 있으니 야생에 가면 안됩니다."
    )
    public static let dreamInfo2 = DreamInfo(
      title: "호랑이를 죽이는 꿈",
      description: "직장이나 학교에서 큰 성취감을 얻을 수 있는 꿈입니다."
    )
    public static let dreamInfo3 = DreamInfo(
      title: "호랑이한테 잡혀가는 꿈",
      description: "호랑이한테 물려가도 정신만 차리면 사는것처럼 항상 정신을 챙겨야합니다."
    )
    public static let dreamInfo4 = DreamInfo(
      title: "사자를 죽이는 꿈",
      description: "라이언킹을 죽였으니 이제 당신이 야생의 주인입니다."
    )
    public static let dreamInfo5 = DreamInfo(
      title: "사자한테 물리는 꿈",
      description: "사자는 호랑이보다 약하니 조금 덜 조심해도 됩니다."
    )
    public static let dreamInfo6 = DreamInfo(
      title: "사자한테 잡혀가는 꿈",
      description: "사자한테 잡혀가면 호랑이와 달리 무리 생활을 하기에 그냥 죽은것입니다."
    )
    public static let dreamInfo7 = DreamInfo(
      title: "머리가 터지는 꿈",
      description: "머리가 너무 아픈일의 연속이 일어나게 됩니다."
    )
    public static let dreamInfo8 = DreamInfo(
      title: "머리를 자르는 꿈",
      description: "시험이나 승진에서 좌절하게 됩니다."
    )
    public static let dreamInfo9 = DreamInfo(
      title: "눈이 안보이는 꿈",
      description: "루테인을 많이 챙겨 드셔야 합니다."
    )
    public static let dreamInfo10 = DreamInfo(
      title: "눈이 떠지는 꿈",
      description: "못보던 세상을 볼 수 있는 선구안을 가지게 됩니다."
    )
  }
}
