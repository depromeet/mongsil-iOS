//
//  KakaoLoginService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/09.
//

import Combine
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

public class KakaoLoginService {
  public init() {}

  public func getKakaoUserInfo() -> AnyPublisher<[String: String], Error> {
    return Publishers.Create<[String: String], Error>(factory: { [unowned self] subscribers -> Cancellable in
      if UserApi.isKakaoTalkLoginAvailable() {
        self.loginWithKakaoTalk { result in
          switch result {
          case let .success(info):
            subscribers.send(info)
          case let .failure(error):
            subscribers.send(completion: .failure(error))
          }
          subscribers.send(completion: .finished)
        }
      } else {
        self.loginWithKakaoAccont { result in
          switch result {
          case let .success(info):
            subscribers.send(info)
          case let .failure(error):
            subscribers.send(completion: .failure(error))
          }
          subscribers.send(completion: .finished)
        }
      }
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }

  private func loginWithKakaoTalk(completion: @escaping (Result<[String: String], Error>) -> Void) {
    UserApi.shared.loginWithKakaoTalk { _, error in
      if let error = error {
        completion(.failure(error))
      }
      UserApi.shared.me { user, error in
        if let error = error {
          completion(.failure(error))
        }
        if let user = user {
          let nickName = user.kakaoAccount?.profile?.nickname ?? ""
          let email = user.kakaoAccount?.email ?? ""
          completion(.success(["name": nickName, "email": email]))
        }
      }
    }
  }

  private func loginWithKakaoAccont(completion: @escaping (Result<[String: String], Error>) -> Void) {
    UserApi.shared.loginWithKakaoAccount { _, error in
      if let error = error {
        completion(.failure(error))
      }
      UserApi.shared.me { user, error in
        if let error = error {
          completion(.failure(error))
        }
        if let user = user {
          let nickName = user.kakaoAccount?.profile?.nickname ?? ""
          let email = user.kakaoAccount?.email ?? ""
          completion(.success(["name": nickName, "email": email]))
        }
      }
    }
  }

  public func hasKakaoToken() -> AnyPublisher<Bool, Error> {
    return Publishers.Create<Bool, Error>(factory: { [unowned self] subscribers -> Cancellable in
      if AuthApi.hasToken() {
        self.accessTokenInfo { result in
          switch result {
          case let .success(hasKakaoToken):
            subscribers.send(hasKakaoToken)
          case let .failure(error):
            subscribers.send(completion: .failure(error))
          }
        }
      } else {
        subscribers.send(false)
      }
      subscribers.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }

  private func accessTokenInfo(completion: @escaping (Result<Bool, Error>) -> Void) {
    UserApi.shared.accessTokenInfo { _, error in
      if let error = error {
        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true {
          completion(.failure(error))
        } else {
          completion(.failure(error))
        }
      } else {
        completion(.success(true))
      }
    }
  }
}
