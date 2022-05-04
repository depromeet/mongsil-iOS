//
//  AppleLoginService.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/04.
//

import AuthenticationServices
import Combine

public class AppleLoginService {
  public var defaults: UserDefaults

  public init(
    defaults: UserDefaults
  ) {
    self.defaults = defaults
  }

  public func hasAppleToken() -> AnyPublisher<Bool, Never> {
    return Publishers.Create<Bool, Never>(factory: { [unowned self] subscribers -> Cancellable in
      guard let userID = self.defaults.string(forKey: "appleUserID") else {
        subscribers.send(false)
        subscribers.send(completion: .finished)
        return AnyCancellable({})
      }

      let appleIDProvider = ASAuthorizationAppleIDProvider()
      appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
        if error != nil {
          subscribers.send(false)
        } else {
          switch credentialState {
          case .authorized:
            subscribers.send(true)
          default:
            subscribers.send(false)
          }
        }
        subscribers.send(completion: .finished)
      }
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }
}
