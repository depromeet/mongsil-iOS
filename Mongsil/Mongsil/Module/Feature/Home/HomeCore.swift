//
//  HomeCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine
import ComposableArchitecture

struct HomeState: Equatable {
}

enum HomeAction {
  case kakaoLoginButtonTapped
  case appleLoginButtonTapped
}

struct HomeEnvironment {
  var kakaoLoginService: KakaoLoginService
  init(
    kakaoLoginService: KakaoLoginService
  ) {
    self.kakaoLoginService = kakaoLoginService
  }
}

let homeReducer = Reducer<WithSharedState<HomeState>, HomeAction, HomeEnvironment> {
  _, action, env in
  switch action {
  case .kakaoLoginButtonTapped:
    return env.kakaoLoginService.getKakaoUserInfo()
      .catchToEffect()
      .flatMapLatest({ result -> Effect<HomeAction, Never> in
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
