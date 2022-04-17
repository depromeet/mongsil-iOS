//
//  ContentView.swift
//  KaKaoLogin
//
//  Created by Chuljin Hwang on 2022/04/09.
//

import Combine
import KakaoSDKUser

class KakaoLoginService{
  
  init() {}
  
  func getKakaoUserInfo() -> AnyPublisher<Void, Never> {
    return Publishers.Create<Void, Never>(factory: { subscriber -> Cancellable in
      subscriber.send(
        UserApi.shared.me { user, error in
          if let error = error {
            print(error)
          }else{
            if let nickname = user?.kakaoAccount?.profile?.nickname {
              print(nickname)
            }
            if let mail = user?.kakaoAccount?.email {
              print(mail)
            }
          }
        }
      )
      subscriber.send(completion: .finished)
      return AnyCancellable({})
    })
    .eraseToAnyPublisher()
  }
}


