//
//  KakaoLoginService.swift
//  Mongsil
//
//  Created by Chuljin Hwang on 2022/04/09.
//

import Combine
import KakaoSDKUser

class KakaoLoginService{
  
  init() {}
  
  func getKakaoUserInfo() -> AnyPublisher<Void, Never> {
    return Publishers.Create<Void, Never>(factory: { subscriber -> Cancellable in
      if (UserApi.isKakaoTalkLoginAvailable()){
        subscriber.send(
          UserApi.shared.loginWithKakaoTalk { (_, error) in
            if error != nil {
            }
            else {
              UserApi.shared.me { user, error in
                if error != nil {
                } else {
                  if let nickname = user?.kakaoAccount?.profile?.nickname {
                  }
                  if let mail = user?.kakaoAccount?.email {
                  }
                }
              }
            }
          }
        )
      } else {
        subscriber.send(
          UserApi.shared.loginWithKakaoAccount { (_, error) in
            if error != nil {
            }
            else {
              print("loginWithKakaoAccount() success.")
              UserApi.shared.me { user, error in
                if error != nil {
                } else {
                  if let nickname = user?.kakaoAccount?.profile?.nickname {
                  }
                  if let mail = user?.kakaoAccount?.email {
                  }
                }
              }
            }
          }
        )
      }
      subscriber.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }
}


