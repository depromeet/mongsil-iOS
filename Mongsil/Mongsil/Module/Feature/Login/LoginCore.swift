//
//  LoginCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/19.
//

import Combine
import ComposableArchitecture

struct LoginState: Equatable {
  var onboardingImage = OnboardingImage.allCases
}

enum LoginAction {
  case backButtonTapped
  case kakaoLoginButtonTapped
  case appleLoginButtonTapped
}

struct LoginEnvironment {
  var kakaoLoginService: KakaoLoginService

  init(
    kakaoLoginService: KakaoLoginService
  ) {
    self.kakaoLoginService = kakaoLoginService
  }
}

let loginReducer = Reducer<WithSharedState<LoginState>, LoginAction, LoginEnvironment> {
  _, action, env in
  switch action {
  case .backButtonTapped:
    return .none

  case .kakaoLoginButtonTapped:
    return env.kakaoLoginService.getKakaoUserInfo()
      .catchToEffect()
      .flatMapLatest({ result -> Effect<LoginAction, Never> in
        switch result {
        case .failure:
          // 토스트 메시지, 얼럿 노출
          return .none
        case let .success(userInfo):
          // 다음 액션 역할 (회원가입)
          return .none
        }
      })
      .eraseToEffect()

  case .appleLoginButtonTapped:
    return .none
  }
}
