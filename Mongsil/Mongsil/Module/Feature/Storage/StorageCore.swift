//
//  StorageCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import Combine
import ComposableArchitecture

struct StorageState: Equatable {
  public var isSettingPushed: Bool = false
  
  // Child State
  public var setting: SettingState?
  
  init(
    isSettingPushed: Bool = false
  ) {
    self.isSettingPushed = isSettingPushed
  }
}

enum StorageAction {
  case setSettingPushed(Bool)
  
  // Child Action
  case setting(SettingAction)
}

struct StorageEnvironment {
}

let storageReducer: Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment> =
Reducer.combine([
  settingReducer
    .optional()
    .pullback(
      state: \.setting,
      action: /StorageAction.setting,
      environment: { _ in
        SettingEnvironment()
      }
    ) as Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment>,
  Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment> {
    state, action, _ in
    switch action {
    case let .setSettingPushed(pushed):
      state.local.isSettingPushed = pushed
      if pushed {
        state.local.setting = .init()
      }
      return .none
      
    case .setting(.backButtonTapped):
      return Effect(value: .setSettingPushed(false))
      
    case .setting:
      return .none
    }
  }
])
