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
  case setShouldDisplayRequestAppTrackingAlert(Bool)
  case displayRequestAppTrackingAlert

  // Child Action
  case mainTab(MainTabAction)
}

struct AppEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var appTrackingService: AppTrackingService
  var kakaoLoginService: KakaoLoginService
  init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    appTrackingService: AppTrackingService,
    kakaoLoginService: KakaoLoginService
  ) {
    self.mainQueue = mainQueue
    self.appTrackingService = appTrackingService
    self.kakaoLoginService = kakaoLoginService
  }
}

let appReducer = Reducer.combine([
  mainTabReducer.pullback(
    state: \.mainTab,
    action: /AppAction.mainTab,
    environment: {
      MainTabEnvironment(
        mainQueue: $0.mainQueue,
        kakaoLoginService: $0.kakaoLoginService
      )
    }
  ) as Reducer<WithSharedState<AppState>, AppAction, AppEnvironment>,
  Reducer<WithSharedState<AppState>, AppAction, AppEnvironment> {
    state, action, env in
    switch action {
    case .onAppear:
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

    case .mainTab:
      return .none
    }
  }
])
