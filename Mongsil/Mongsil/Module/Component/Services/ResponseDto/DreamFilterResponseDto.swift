//
//  DreamFilterResponseDto.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/14.
//

import Foundation

public struct DreamFilterResponseDto: Decodable {
  public let noun: [Noun]
  public let verb: [Verb]

  public init(
    noun: [Noun],
    verb: [Verb]
  ) {
    self.noun = noun
    self.verb = verb
  }

  public enum CodingKeys: String, CodingKey {
    case noun
    case verb = "verbAndAdjective"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.noun = try container.decode([Noun].self, forKey: .noun)
    self.verb = try container.decode([Verb].self, forKey: .verb)
  }
}
