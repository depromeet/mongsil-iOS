//
//  UserService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/01.
//

import Alamofire
import Combine
import CombineExt

public class UserService {
  public typealias ErrorFactory = UserServiceErrorFactory

  public var defaults: UserDefaults
  public let alamofireSession: Session

  public init(
    defaults: UserDefaults,
    alamofireSession: Session
  ) {
    self.defaults = defaults
    self.alamofireSession = alamofireSession
  }

  public func isLogined() -> AnyPublisher<Bool, Never> {
    return Publishers.Create<Bool, Never>(factory: { [unowned self] subscribers -> Cancellable in
      if self.defaults.object(forKey: "isLogined") == nil {
        subscribers.send(false)
      } else {
        subscribers.send(true)
      }
      subscribers.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }

  public func setLoginInfo(
    isLogined: Bool,
    isKakao: Bool,
    name: String,
    email: String,
    appleUserID: String? = nil
  ) -> AnyPublisher<Void, Never> {
    return Publishers.Create<Void, Never>(factory: { [unowned self] subscribers -> Cancellable in
      subscribers.send(
        self.setUserDefaults(
          isLogined: isLogined,
          isKakao: isKakao,
          name: name,
          email: email,
          appleUserID: appleUserID
        )
      )
      subscribers.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }

  public func searchUserID(with email: String) ->  AnyPublisher<CheckUserResponseDto, Error> {
    let url = "3.34.46.139:3000\(URLHost.checkUser)"
    let body = CheckUserRequestDto(userEmail: email)

    return alamofireSession
      .request(
        url,
        method: .post,
        parameters: body,
        encoder: JSONParameterEncoder.default
      )
      .validate(statusCode: 200..<300)
      .publishData()
      .tryMap({ dataResponse -> CommonResponseDto.ExistData<CheckUserResponseDto> in
        switch dataResponse.result {
        case let .success(data):
          do {
            return try JSONDecoder().decode(CommonResponseDto.ExistData<CheckUserResponseDto>.self, from: data)
          } catch {
            throw ErrorFactory.decodeFailed(
              url: url,
              data: data,
              underlying: error
            )
          }
        case let .failure(error):
          throw ErrorFactory.checkUserFailed(url: url, underlying: error)
        }
      })
      .tryMap({ response -> CommonResponseDto.ExistData<CheckUserResponseDto> in
        if response.statusCode == "200" {
          return response
        } else {
          throw ErrorFactory.checkUserFailed(
            url: url,
            statusCode: response.statusCode,
            underlying: nil
          )
        }
      })
      .compactMap { $0.data }
      .eraseToAnyPublisher()
  }

  private func setUserDefaults(
    isLogined: Bool,
    isKakao: Bool,
    name: String,
    email: String,
    appleUserID: String? = nil
  ) {
    self.defaults.set(isLogined, forKey: "isLogined")
    if isKakao {
      self.defaults.set(isKakao, forKey: "isKakao")
      self.defaults.set(name, forKey: "kakaoName")
      self.defaults.set(email, forKey: "kakaoEmail")
    } else {
      self.defaults.set(isKakao, forKey: "isKakao")
      self.defaults.set(name, forKey: "appleName")
      self.defaults.set(email, forKey: "appleEmail")
      self.defaults.set(appleUserID, forKey: "appleUserID")
    }
  }
}

public enum UserServiceErrorFactory: ErrorFactory {
  public enum Code: Int {
    case decodeFailed = 1
    case checkUserFailed = 2
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

  public static func checkUserFailed(
    url: String,
    statusCode: String? = nil,
    underlying: Error? = nil
  ) -> NSError {
    return NSError(
      domain: domain,
      code: Code.checkUserFailed.rawValue,
      userInfo: [
        "identifier": String(reflecting: Code.checkUserFailed),
        "url": url,
        "statusCode": statusCode as Any,
        NSUnderlyingErrorKey: underlying as Any
      ]
    )
  }
}
