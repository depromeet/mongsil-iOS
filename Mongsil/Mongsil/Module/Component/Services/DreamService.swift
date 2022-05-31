//
//  DreamService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/31.
//

import Alamofire
import Combine
import CombineExt

public class DreamService {
  public typealias ErrorFactory = DreamServiceErrorFactory

  public let alamofireSession: Session

  public init(alamofireSession: Session) {
    self.alamofireSession = alamofireSession
  }

  public func getHotKeywords() -> AnyPublisher<HotKeyword, Error> {
    let url = "http://3.34.46.139:80\(URLHost.hotKeyword)"

    return alamofireSession
      .request(
        url,
        method: .get,
        encoding: JSONEncoding.default
      )
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap({ dataResponse -> CommonResponseDto.ExistData<HotKeyword> in
        switch dataResponse.result {
        case let .success(data):
          do {
            return try
            JSONDecoder().decode(CommonResponseDto.ExistData<HotKeyword>.self, from: data)
          } catch {
            throw ErrorFactory.decodeFailed(
              url: url,
              data: data,
              underlying: error
            )
          }
        case let .failure(error):
          throw ErrorFactory.getHotKeywordFailed(url: url, underlying: error)
        }
      })
      .tryMap({ response -> CommonResponseDto.ExistData<HotKeyword> in
        if response.statusCode == 200 {
          return response
        } else {
          throw ErrorFactory.getHotKeywordFailed(
            url: url,
            statusCode: response.statusCode,
            underlying: nil
          )
        }
      })
      .compactMap { $0.data }
      .eraseToAnyPublisher()
  }
}

public enum DreamServiceErrorFactory: ErrorFactory {
  public enum Code: Int {
    case decodeFailed = 1
    case getHotKeywordFailed = 2
  }

  public static func decodeFailed(
    url: String,
    data: Data,
    underlying: Error
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.decodeFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.decodeFailed),
        "url": url,
        "data": data,
        NSUnderlyingErrorKey: underlying
      ]
    )
  }

  public static func getHotKeywordFailed(
    url: String,
    statusCode: Int? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getHotKeywordFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getHotKeywordFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }
}
