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
}

let loginReducer = Reducer<WithSharedState<LoginState>, LoginAction, LoginEnvironment> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none

  case .kakaoLoginButtonTapped:
    return .none

  case .appleLoginButtonTapped:
    return .none
  }
}
