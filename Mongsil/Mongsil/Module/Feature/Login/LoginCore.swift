//
//  LoginCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/19.
//

import Combine
import ComposableArchitecture
import KakaoSDKUser

struct LoginState: Equatable {
  var onboardingImage = OnboardingImage.allCases
}

enum LoginAction: ToastPresentableAction {
  case backButtonTapped
  case kakaoLoginButtonTapped
  case appleLoginCompleted(String, String, String)
  case appleLoginNotCompleted
  case searchUser(String, String)
  case signUpUser(String, String)
  case setUserID(String)
  case setLoginInfo(Bool, Bool, String, String, String? = nil)
  case loginCompleted
  case presentToast(String)
}

struct LoginEnvironment {
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  var mainQueue: AnySchedulerOf<DispatchQueue>

  init(
    kakaoLoginService: KakaoLoginService,
    userService: UserService,
    signUpService: SignUpService,
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.kakaoLoginService = kakaoLoginService
    self.userService = userService
    self.signUpService = signUpService
    self.mainQueue = mainQueue
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
          let nickName = userInfo["name"] ?? ""
          let email = userInfo["email"] ?? ""
          return Effect.concatenate([
            Effect(value: .searchUser(nickName, email)),
            Effect(value: .setLoginInfo(true, true, nickName, email))
          ])
        }
      })
      .eraseToEffect()

  case let .appleLoginCompleted(nickName, email, appleUserID):
    return Effect.concatenate([
      Effect(value: .searchUser(nickName, email)),
      Effect(value: .setLoginInfo(true, false, nickName, email, appleUserID))
    ])

  case .appleLoginNotCompleted:
    return Effect(value: .presentToast("애플 로그인에 실패했습니다."))

  case let .searchUser(name, email):
    return env.userService.searchUserID(with: email)
      .catchToEffect()
      .map({ result in
        switch result {
        case let .success(response):
          if response.checkValue {
            guard let userID = response.userID else {
              return LoginAction.presentToast("회원 ID가 없습니다.")
            }
            return LoginAction.setUserID(userID)
          } else {
            return LoginAction.signUpUser(name, email)
          }
        case let .failure(error):
          return LoginAction.presentToast("회원 조회에 실패하였습니다.")
        }
      })

  case let .signUpUser(name, email):
    return env.signUpService.signUp(name: name, with: email)
      .delay(for: .milliseconds(300), scheduler: env.mainQueue)
      .catchToEffect()
      .map({ result in
        switch result {
        case let .success(response):
          let userID = response.userID
          return LoginAction.setUserID(userID)
        case let .failure(error):
          return LoginAction.presentToast("회원 가입에 실패했습니다.")
        }
      })

  case let .setLoginInfo(isLogined, isKakao, name, email, appleUserID):
    return env.userService.setLoginInfo(
      isLogined: isLogined,
      isKakao: isKakao,
      name: name,
      email: email,
      appleUserID: appleUserID
    )
    .delay(for: .milliseconds(500), scheduler: env.mainQueue)
    .eraseToEffect()
    .map({ _ -> LoginAction in
      if email != "" {
        return .loginCompleted
      }
      UserApi.shared.unlink {(error) in
        if let error = error {
          print(error)
        }
      }
      return .presentToast("이메일 동의를 해주셔야 정상적으로 기능 사용이 가능합니다.\n이메일 정보 제공에 동의해주세요!")
    })
    .eraseToEffect()

  case .loginCompleted:
    return Effect(value: .presentToast("로그인을 완료했어요!"))

  case .presentToast:
    return .none

  case let .setUserID(userID):
    return .none
  }
}
