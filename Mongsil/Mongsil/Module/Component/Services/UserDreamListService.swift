//
//  UserDreamListService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/17.
//

import Alamofire
import Combine
import CombineExt

public class UserDreamListService {
  public typealias ErrorFactory = UserDreamListServiceErrorFactory

  public let alamofireSession: Session

  public init(alamofireSession: Session) {
    self.alamofireSession = alamofireSession
  }

  public func getUserDreamList(userID: String) -> AnyPublisher<UserDreamList, Error> {
    let url = "http://3.39.22.137\(URLHost.dreamList)"
    let body = UserDreamListRequestDto(userID: userID)

    return alamofireSession.request(
      url,
      method: .post,
      parameters: body,
      encoder: JSONParameterEncoder.default
    )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.ExistData<UserDreamList> in
      switch dataResponse.result {
      case let .success(data):
        do {
          let decoder = JSONDecoder()
          decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
          return try decoder.decode(CommonResponseDto.ExistData<UserDreamList>.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.getUserDreamListFailed(
          url: url,
          userID: userID,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.ExistData<UserDreamList> in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.getUserDreamListFailed(
          url: url,
          statusCode: response.statusCode,
          userID: userID,
          underlying: nil
        )
      }
    })
    .compactMap { $0.data }
    .eraseToAnyPublisher()
  }

  public func deleteUserDreamList(dreamIDs: [String]) -> AnyPublisher<Unit, Error> {
    let url = "http://3.39.22.137\(URLHost.dreamList)"
    let body = UserDreamListIDRequestDto(dreamIDList: dreamIDs)

    return alamofireSession.request(
      url,
      method: .delete,
      parameters: body,
      encoder: JSONParameterEncoder.default
    )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.NotExistData in
      switch dataResponse.result {
      case let .success(data):
        do {
          return try JSONDecoder().decode(CommonResponseDto.NotExistData.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.deleteUserDreamListFailed(
          url: url,
          dreamIDs: dreamIDs,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.NotExistData in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.deleteUserDreamListFailed(
          url: url,
          statusCode: response.statusCode,
          dreamIDs: dreamIDs,
          underlying: nil
        )
      }
    })
    .mapTo(Unit())
    .eraseToAnyPublisher()
  }

  public func saveUserDream(
    userID: String,
    dreamID: String
  ) -> AnyPublisher<Unit, Error> {
    let url = "http://3.39.22.137\(URLHost.saveDream)"
    let body = SaveDreamRequestDto(
      userID: userID,
      dreamID: dreamID
    )

    return alamofireSession.request(
      url,
      method: .post,
      parameters: body,
      encoder: JSONParameterEncoder.default
    )
    .validate(statusCode: 200..<300)
    .publishData()
    .tryMap({ dataResponse -> CommonResponseDto.NotExistData in
      switch dataResponse.result {
      case let .success(data):
        do {
          return try JSONDecoder().decode(CommonResponseDto.NotExistData.self, from: data)
        } catch {
          throw ErrorFactory.decodeFailed(
            url: url,
            data: data,
            underlying: error
          )
        }
      case let .failure(error):
        throw ErrorFactory.saveDreamFailed(
          url: url,
          userID: userID,
          DreamID: dreamID,
          underlying: error
        )
      }
    })
    .tryMap({ response -> CommonResponseDto.NotExistData in
      if response.statusCode == 200 {
        return response
      } else {
        throw ErrorFactory.saveDreamFailed(
          url: url,
          statusCode: response.statusCode,
          userID: userID,
          DreamID: dreamID,
          underlying: nil
        )
      }
    })
    .mapTo(Unit())
    .eraseToAnyPublisher()
  }
}

public enum UserDreamListServiceErrorFactory: ErrorFactory {
  public enum Code: Int {
    case decodeFailed = 1
    case getUserDreamListFailed = 2
    case deleteUserDreamListFailed = 3
    case saveDreamFailed = 4
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

  public static func getUserDreamListFailed(
    url: String,
    statusCode: Int? = nil,
    userID: String,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.getUserDreamListFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.getUserDreamListFailed),
        "url": url,
        "statusCode": statusCode as Any,
        "userID": userID,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func deleteUserDreamListFailed(
    url: String,
    statusCode: Int? = nil,
    dreamIDs: [String],
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.deleteUserDreamListFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.deleteUserDreamListFailed),
        "url": url,
        "statusCode": statusCode as Any,
        "dreamIDs": dreamIDs,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }

  public static func saveDreamFailed(
    url: String,
    statusCode: Int? = nil,
    userID: String,
    DreamID: String,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.saveDreamFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.saveDreamFailed),
        "url": url,
        "statusCode": statusCode as Any,
        "userID": userID,
        "dreamID": DreamID,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }
}
