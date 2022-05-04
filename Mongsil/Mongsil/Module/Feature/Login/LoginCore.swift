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

enum LoginAction: ToastPresentableAction {
  case backButtonTapped
  case kakaoLoginButtonTapped
  case appleLoginCompleted(String, String, String)
  case appleLoginNotCompleted
  case setLoginInfo(Bool, Bool, String, String, String? = nil)
  case loginCompleted
  case presentToast(String)
}

struct LoginEnvironment {
  var kakaoLoginService: KakaoLoginService
  var userService: UserService

  init(
    kakaoLoginService: KakaoLoginService,
    userService: UserService
  ) {
    self.kakaoLoginService = kakaoLoginService
    self.userService = userService
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
          return Effect(value: .presentToast("카카오 로그인에 실패했습니다."))
        case let .success(userInfo):
          // 회원조회 및 가입 연동
          return Effect(value: .setLoginInfo(
            true,
            true,
            userInfo["nickName"] ?? "",
            userInfo["email"] ?? ""
          ))
        }
      })
      .eraseToEffect()

  case let .appleLoginCompleted(nickName, email, userID):
    // 회원조회 및 가입 연동
    return Effect(value: .setLoginInfo(true, false, nickName, email, userID))

  case .appleLoginNotCompleted:
    return Effect(value: .presentToast("애플 로그인에 실패했습니다."))

  case let .setLoginInfo(isLogined, isKakao, name, email, userID):
    return env.userService.setLoginInfo(
      isLogined: isLogined,
      isKakao: isKakao,
      name: name,
      email: email,
      userID: userID
    )
    .map({ _ -> LoginAction in
      return .loginCompleted
    })
    .eraseToEffect()

  case .loginCompleted:
    return Effect(value: .presentToast("로그인을 완료했어요!"))

  case .presentToast:
    return .none
  }
}
