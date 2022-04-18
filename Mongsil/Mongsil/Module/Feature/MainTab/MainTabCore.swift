//
//  MainTabCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import Combine
import ComposableArchitecture

struct MainTabState: Equatable {
  public var isRecordButtonTapped: Bool = false
  //Child state
  public  var home: HomeState = .init()
  public var record: RecordState?
  public var store: StorageState = .init()
  
  init(
    isRecordButtonTapped: Bool = false
  ) {
    self.isRecordButtonTapped = isRecordButtonTapped
  }
}

enum MainTabAction {
  case setBackToHome(Bool)
  case moveToRecordViewButtonTapped(Bool)
  // Child Action
  case home(HomeAction)
  case record(RecordAction)
  case store(StorageAction)
}

struct MainTabEnvironment {
}

let tabReducer:
Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment> =
Reducer.combine([
  recordReducer
    .optional()
    .pullback(
      state: \.record,
      action: /MainTabAction.record,
      environment: { _ in
        RecordEnvironment ()
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment> {
    state, action, env in
    switch action {
    case let .moveToRecordViewButtonTapped(isTapped):
      state.local.isRecordButtonTapped = isTapped
      if isTapped {
        state.local.record = .init()
      }
      return .none
      
    case let .setBackToHome(pushed):
      state.local.isRecordButtonTapped = pushed
      if pushed {
        state.local.record = .init()
      }
      return .none
      
    case .record(.backButtonTapped):
      return Effect(value: .setBackToHome(false))
      
    case .home:
      return .none
      
    case .record:
      return .none
      
    case .store:
      return .none
    }
  }
])
