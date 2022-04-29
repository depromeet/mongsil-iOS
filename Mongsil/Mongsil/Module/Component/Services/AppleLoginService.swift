//
//  AppleLoginService.swift
//  Mongsil
//
//  Created by Chuljin Hwang on 2022/04/29.
//

import Combine
import AuthenticationServices

class AppleLoginService{
  func getUserInfo() -> AnyPublisher<[String: String], Error>
  {
    return Publishers.Create<[String: String], Error>(factory: { [unowned self] substribers -> Cancellable in
      let request = ASAuthorizationAppleIDProvider().createRequest()
      request.requestedScopes = [.fullName, .email]
      let controller = ASAuthorizationController(authorizationRequests: [request])
      controller.delegate = self as? ASAuthorizationControllerDelegate
      controller.presentationContextProvider = self as? ASAuthorizationControllerPresentationContextProviding
      controller.performRequests()
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }
}
