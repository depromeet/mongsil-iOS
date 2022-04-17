//
//  HomeCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine
import ComposableArchitecture

struct HomeState: Equatable {
  var kakaoUserNickname : String = "Kakao nickname initial value"
  var kakaoUserMail : String = "Kakao email initial value"
  var appleUserNickname : String = "Apple nickname initial value"
  var appleUserMail : String = "Apple email initial value"
}

enum HomeAction {
  case kakaoLoginButtonTapped
  case appleLoginButtonTapped
}

struct HomeEnvironment {
  var kakaoLoginService: KakaoLoginService
  var appleLoginService: AppleLoginService
  init(
    kakaoLoginService: KakaoLoginService,
    appleLoginService: AppleLoginService
  ){
    self.kakaoLoginService = kakaoLoginService
    self.appleLoginService = appleLoginService
  }
}

let homeReducer = Reducer<HomeState, HomeAction, HomeEnvironment> {
  state, action, env in
  switch action {
  case .kakaoLoginButtonTapped:
    return env.kakaoLoginService.getKakaoUserInfo()
    
  case .appleLoginButtonTapped:
    return .none
  }
}
