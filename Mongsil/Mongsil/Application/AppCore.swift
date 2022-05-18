//
//  AppCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine
import ComposableArchitecture

struct AppState: Equatable {
  var shouldDisplayRequestAppTrackingAlert: Bool = false
  var mainTab: MainTabState = .init()
}

enum AppAction {
  case onAppear
  case checkDisplayAppTrackingAlert
  case setShouldDisplayRequestAppTrackingAlert(Bool)
  case displayRequestAppTrackingAlert
  case checkIsLogined
  case checkHasKakaoToken
  case checkHasAppleToken
  case setIsLogined(Bool)
  case presentToast(String, Bool = true)
  case hideToast
  case noop

  // Child Action
  case mainTab(MainTabAction)
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var appTrackingService: AppTrackingService
  var kakaoLoginService: KakaoLoginService
  var appleLoginService: AppleLoginService
  var userService: UserService
  var signUpService: SignUpService

  init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    appTrackingService: AppTrackingService,
    kakaoLoginService: KakaoLoginService,
    appleLoginService: AppleLoginService,
    userService: UserService,
    signUpService: SignUpService
  ) {
    self.mainQueue = mainQueue
    self.appTrackingService = appTrackingService
    self.kakaoLoginService = kakaoLoginService
    self.appleLoginService = appleLoginService
    self.userService = userService
    self.signUpService = signUpService
  }
}

let appReducer = Reducer.combine([
  mainTabReducer.pullback(
    state: \.mainTab,
    action: /AppAction.mainTab,
    environment: {
      MainTabEnvironment(
        mainQueue: $0.mainQueue,
        kakaoLoginService: $0.kakaoLoginService,
        userService: $0.userService,
        signUpService: $0.signUpService
      )
    }
  ) as Reducer<WithSharedState<AppState>, AppAction, AppEnvironment>,
  Reducer<WithSharedState<AppState>, AppAction, AppEnvironment> {
    state, action, env in
    struct ToastCancelId: Hashable {}

    switch action {
    case .onAppear:
      return Effect.merge([
        Effect(value: .checkDisplayAppTrackingAlert),
        Effect(value: .checkIsLogined)
      ])

    case .checkDisplayAppTrackingAlert:
      return env.appTrackingService.getTrackingAuthorizationStatus()
        .map({ status -> AppAction in
          return .setShouldDisplayRequestAppTrackingAlert(status)
        })
        .delay(for: .milliseconds(100), scheduler: env.mainQueue)
        .eraseToEffect()

    case let .setShouldDisplayRequestAppTrackingAlert(status):
      state.local.shouldDisplayRequestAppTrackingAlert = status
      return .none

    case .displayRequestAppTrackingAlert:
      return env.appTrackingService.requestAppTrackingAuthorization()
        .fireAndForget()

    case .checkIsLogined:
      let isKakao = UserDefaults.standard.bool(forKey: "isKakao")
      return env.userService.isLogined()
        .map({ isLogined -> AppAction in
          if isLogined {
            return isKakao ? .checkHasKakaoToken : .checkHasAppleToken
          }
          return .noop
        })
        .eraseToEffect()

    case .checkHasKakaoToken:
      return env.kakaoLoginService.hasKakaoToken()
        .catchToEffect()
        .flatMapLatest({ result -> Effect<AppAction, Never> in
          switch result {
          case .failure:
            return Effect(value: .presentToast("카카오 로그인 연동 이력을 가져오는데 실패했습니다."))
          case let .success(hasKakaoToken):
            return Effect(value: .setIsLogined(hasKakaoToken))
          }
        })
        .eraseToEffect()

    case .checkHasAppleToken:
      return env.appleLoginService.hasAppleToken()
        .map({ result -> AppAction in
          return .setIsLogined(result)
        })
        .eraseToEffect()

    case let .setIsLogined(isLogined):
      UserDefaults.standard.set(isLogined, forKey: "isLogined")
      return .none

    case let .presentToast(toastText, isBottomPosition):
      state.shared.toastText = toastText
      state.shared.isToastBottomPosition = isBottomPosition
      return Effect<AppAction, Never>.concatenate([
        .cancel(id: ToastCancelId()),
        Effect<AppAction, Never>(value: .hideToast)
          .delay(for: 3, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: ToastCancelId(), cancelInFlight: true)
      ])

    case .hideToast:
      state.shared.toastText = nil
      return .none

    case let .mainTab(.login(.presentToast(text))):
      return Effect(value: .presentToast(text))

    case let .mainTab(.record(.presentToast(text))):
      return Effect(value: .presentToast(text))

    case .mainTab:
      return .none

    case .noop:
      return .none
    }
  }
])
