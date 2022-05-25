//
//  CommonResponseDto.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/06.
//

public enum CommonResponseDto {
  public struct ExistData<T: Decodable>: Decodable {
    public var statusCode: Int
    public var message: String
    public var data: T?

    public enum CodingKeys: String, CodingKey {
      case statusCode, message, data
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.statusCode = try container.decode(Int.self, forKey: .statusCode)
      self.message = try container.decode(String.self, forKey: .message)
      self.data = try container.decode(T?.self, forKey: .data)
    }
  }

  public struct NotExistData: Decodable {
    public var statusCode: Int
    public var message: String

    public enum CodingKeys: String, CodingKey {
      case statusCode, message
    }

    public init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      self.statusCode = try container.decode(Int.self, forKey: .statusCode)
      self.message = try container.decode(String.self, forKey: .message)
    }
  }
}
