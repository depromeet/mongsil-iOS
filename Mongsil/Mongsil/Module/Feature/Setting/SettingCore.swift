//
//  SettingCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import Combine
import ComposableArchitecture

struct SettingState: Equatable {
  public var isProfilePushed: Bool = false
  public var isAppInfoPushed: Bool = false
  public var profile: ProfileState?
  public var appInfo: AppInfoState?

  init(
    isProfilePushed: Bool = false,
    isAppInfoPushed: Bool = false
  ) {
    self.isProfilePushed = isProfilePushed
    self.isAppInfoPushed = isAppInfoPushed
  }
}

enum SettingAction {
  case backButtonTapped
  case setProfilePushed(Bool)
  case setAppInfoPushed(Bool)

  // Child Action
  case appInfo(AppInfoAction)
  case profile(ProfileAction)
}

struct SettingEnvironment {

}

let settingReducer: Reducer<WithSharedState<SettingState>, SettingAction, SettingEnvironment> =
Reducer.combine([
  appInfoReducer
    .optional()
    .pullback(
      state: \.appInfo,
      action: /SettingAction.appInfo,
      environment: { _ in
        AppInfoEnvironment()
      }
    ) as Reducer<WithSharedState<SettingState>, SettingAction, SettingEnvironment>,
  profileReducer
    .optional()
    .pullback(
      state: \.profile,
      action: /SettingAction.profile,
      environment: { _ in
        ProfileEnvironment()
      }
    ) as Reducer<WithSharedState<SettingState>, SettingAction, SettingEnvironment>,
  Reducer<WithSharedState<SettingState>, SettingAction, SettingEnvironment> {
    state, action, _ in
    switch action {
    case .backButtonTapped:
      return .none

    case let .setProfilePushed(pushed):
      state.local.isProfilePushed = pushed
      if pushed {
        state.local.profile = .init()
      }
      return .none

    case let .setAppInfoPushed(pushed):
      state.local.isAppInfoPushed = pushed
      if pushed {
        state.local.appInfo = .init()
      }
      return .none

    case .profile(.backButtonTapped):
      return Effect(value: .setProfilePushed(false))

    case .profile:
      return .none

    case .appInfo(.backButtonTapped):
      return Effect(value: .setAppInfoPushed(false))

    case .appInfo:
      return .none
    }
  }
])
