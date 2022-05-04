//
//  UserService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/01.
//

import Combine
import CombineExt

public class UserService {
  public var defaults: UserDefaults

  public init(
    defaults: UserDefaults
  ) {
    self.defaults = defaults
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
    userID: String? = nil
  ) -> AnyPublisher<Void, Never> {
    return Publishers.Create<Void, Never>(factory: { [unowned self] subscribers -> Cancellable in
      subscribers.send(
        self.setUserDefaults(
          isLogined: isLogined,
          isKakao: isKakao,
          name: name,
          email: email,
          userID: userID
        )
      )
      subscribers.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }

  private func setUserDefaults(
    isLogined: Bool,
    isKakao: Bool,
    name: String,
    email: String,
    userID: String? = nil
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
      self.defaults.set(userID, forKey: "appleUserID")
    }
  }
}
