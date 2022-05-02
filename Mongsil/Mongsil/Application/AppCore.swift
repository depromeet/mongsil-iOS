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
  case presentToast(String, Bool = true)
  case hideToast
  
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
    struct ToastCancelId: Hashable {}
    
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
      
    case .mainTab(.login(.loginCompleted)):
      state.shared.isLogined = true
      return .none
      
    case let .mainTab(.login(.presentToast(text))):
      return Effect(value: .presentToast(text))
      
    case .mainTab:
      return .none
    }
  }
])
