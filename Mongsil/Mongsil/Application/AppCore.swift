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
}

enum AppAction {
  case onAppear
  case setShouldDisplayRequestAppTrackingAlert(Bool)
  case displayRequestAppTrackingAlert
}

struct AppEnvironment {
  var appTrackingService: AppTrackingService
  
  init(
    appTrackingService: AppTrackingService
  ){
    self.appTrackingService = appTrackingService
  }
}

let appReducer = Reducer<AppState, AppAction, AppEnvironment> {
  state, action, env in
  switch action {
  case .onAppear:
    return env.appTrackingService.getTrackingAuthorizationStatus()
      .map({ status -> AppAction in
        return .setShouldDisplayRequestAppTrackingAlert(status)
      })
      .eraseToEffect()
    
  case let .setShouldDisplayRequestAppTrackingAlert(status):
    state.shouldDisplayRequestAppTrackingAlert = status
    return .none
    
  case .displayRequestAppTrackingAlert:
    return env.appTrackingService.requestAppTrackingAuthorization()
      .fireAndForget()
  }
}
