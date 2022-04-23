//
//  KakaoLoginService.swift
//  Mongsil
//
//  Created by Chuljin Hwang on 2022/04/09.
//

import Combine
import KakaoSDKUser

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
          completion(.success(["nickName": nickName, "email": email]))
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
          completion(.success(["nickName": nickName, "email": email]))
        }
      }
    }
  }
}
