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

  public func getDreamFilter() -> AnyPublisher<DreamFilterResponseDto, Error> {
    let url = "http://3.39.22.137\(URLHost.dreamFilter)"

    return alamofireSession
      .request(
        url,
        method: .get,
        encoding: JSONEncoding.default
      )
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap({ dataResponse -> CommonResponseDto.ExistData<DreamFilterResponseDto> in
        switch dataResponse.result {
        case let .success(data):
          do {
            return try
            JSONDecoder().decode(CommonResponseDto.ExistData<DreamFilterResponseDto>.self, from: data)
          } catch {
            throw ErrorFactory.decodeFailed(
              url: url,
              data: data,
              underlying: error
            )
          }
        case let .failure(error):
          throw ErrorFactory.getDreamFilterFailed(url: url, underlying: error)
        }
      })
      .tryMap({ response -> CommonResponseDto.ExistData<DreamFilterResponseDto> in
        if response.statusCode == 200 {
          return response
        } else {
          throw ErrorFactory.getDreamFilterFailed(
            url: url,
            statusCode: response.statusCode,
            underlying: nil
          )
        }
      })
      .compactMap { $0.data }
      .eraseToAnyPublisher()
  }

  public func getHotKeywords() -> AnyPublisher<HotKeyword, Error> {
    let url = "http://3.39.22.137\(URLHost.hotKeyword)"

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

  public func getSearchResult(keyword: String, categories: [String]) -> AnyPublisher<[SearchResult], Error> {
    let url = "http://3.39.22.137\(URLHost.dreamSearch)?word=\(keyword)&categories=\(categories.joined(separator: ","))".decodeURL()

    return alamofireSession
      .request(
        url,
        method: .get,
        encoding: JSONEncoding.default
      )
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap({ dataResponse -> CommonResponseDto.ExistData<GetDreamSearchResultResponseDto> in
        switch dataResponse.result {
        case let .success(data):
          do {
            return try JSONDecoder().decode(CommonResponseDto.ExistData<GetDreamSearchResultResponseDto>.self, from: data)
          } catch {
            throw ErrorFactory.decodeFailed(
              url: url,
              data: data,
              underlying: error
            )
          }
        case let .failure(error):
          throw ErrorFactory.getSearchResultFailed(url: url, underlying: error)
        }
      })
      .tryMap({ response -> CommonResponseDto.ExistData<GetDreamSearchResultResponseDto> in
        if (200..<300).contains(response.statusCode) {
          return response
        } else {
          throw ErrorFactory.getSearchResultFailed(
            url: url,
            statusCode: response.statusCode,
            underlying: nil
          )
        }
      })
      .map { $0.data?.searchResult ?? []}
      .eraseToAnyPublisher()
  }

  public func getSearchResultCount(keyword: String, categories: [String]) -> AnyPublisher<Int, Error> {
    let url = "http://3.39.22.137\(URLHost.dreamSearchCount)?word=\(keyword)&categories=\(categories.joined(separator: ","))".decodeURL()

    return alamofireSession
      .request(
        url,
        method: .get,
        encoding: JSONEncoding.default
      )
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap({ dataResponse -> CommonResponseDto.ExistData<GetDreamSearchResultCountResponseDto> in
        switch dataResponse.result {
        case let .success(data):
          do {
            return try JSONDecoder().decode(CommonResponseDto.ExistData<GetDreamSearchResultCountResponseDto>.self, from: data)
          } catch {
            throw ErrorFactory.decodeFailed(
              url: url,
              data: data,
              underlying: error
            )
          }
        case let .failure(error):
          throw ErrorFactory.getSearchResultCountFailed(url: url, underlying: error)
        }
      })
      .tryMap({ response -> CommonResponseDto.ExistData<GetDreamSearchResultCountResponseDto> in
        if (200..<300).contains(response.statusCode) {
          return response
        } else {
          throw ErrorFactory.getSearchResultCountFailed(
            url: url,
            statusCode: response.statusCode,
            underlying: nil
          )
        }
      })
      .compactMap { $0.data?.count }
      .eraseToAnyPublisher()
  }

  public func getSearchResultDetail(id: String) -> AnyPublisher<Dream, Error> {
    let url = "http://3.39.22.137\(URLHost.selectDream)/\(id)".decodeURL()

    return alamofireSession
      .request(
        url,
        method: .get,
        encoding: JSONEncoding.default
      )
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap({ dataResponse -> CommonResponseDto.ExistData<GetDreamSearchResultDetailResponseDto> in
        switch dataResponse.result {
        case let .success(data):
          do {
            return try JSONDecoder().decode(CommonResponseDto.ExistData<GetDreamSearchResultDetailResponseDto>.self, from: data)
          } catch {
            throw ErrorFactory.decodeFailed(
              url: url,
              data: data,
              underlying: error
            )
          }
        case let .failure(error):
          throw ErrorFactory.getSearchResultDetailFailed(url: url, underlying: error)
        }
      })
      .tryMap({ response -> CommonResponseDto.ExistData<GetDreamSearchResultDetailResponseDto> in
        if (200..<300).contains(response.statusCode) {
          return response
        } else {
          throw ErrorFactory.getSearchResultDetailFailed(
            url: url,
            statusCode: response.statusCode,
            underlying: nil
          )
        }
      })
      .compactMap { $0.data?.searchResultDetail }
      .eraseToAnyPublisher()
  }

}

public enum DreamServiceErrorFactory: ErrorFactory {
  public enum Code: Int {
    case decodeFailed = 1
    case getHotKeywordFailed = 2
    case getDreamFilterFailed = 3
    case getSearchResultFailed = 4
    case getSearchResultCountFailed = 5
    case getSearchResultDetailFailed = 6
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

  public static func getDreamFilterFailed(
    url: String,
    statusCode: Int? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getDreamFilterFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getDreamFilterFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func getSearchResultFailed(
    url: String,
    statusCode: Int? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getSearchResultFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getSearchResultFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func getSearchResultCountFailed(
    url: String,
    statusCode: Int? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getSearchResultCountFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getSearchResultCountFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func getSearchResultDetailFailed(
    url: String,
    statusCode: Int? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getSearchResultDetailFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getSearchResultDetailFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }
}
