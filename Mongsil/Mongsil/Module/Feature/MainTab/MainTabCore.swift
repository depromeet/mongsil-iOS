//
//  MainTabCore.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import Combine
import ComposableArchitecture

struct MainTabState: Equatable {
  public var isRecordPushed: Bool = false
  
  // Child State
  public var home: HomeState = .init()
  public var record: RecordState?
  public var storage: StorageState = .init()
  
  init(
    isRecordPushed: Bool = false
  ) {
    self.isRecordPushed = isRecordPushed
  }
}

enum MainTabAction {
  case setRecordPushed(Bool)
  
  // Child Action
  case home(HomeAction)
  case record(RecordAction)
  case storage(StorageAction)
}

struct MainTabEnvironment {
}

let tabReducer:
Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment> =
Reducer.combine([
  homeReducer
    .pullback(
      state: \.home,
      action: /MainTabAction.home,
      environment: { _ in
        HomeEnvironment()
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  recordReducer
    .optional()
    .pullback(
      state: \.record,
      action: /MainTabAction.record,
      environment: { _ in
        RecordEnvironment()
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  storageReducer
    .pullback(
      state: \.storage,
      action: /MainTabAction.storage,
      environment: { _ in
        StorageEnvironment()
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment> {
    state, action, _ in
    switch action {
    case let .setRecordPushed(pushed):
      state.local.isRecordPushed = pushed
      if pushed {
        state.local.record = .init()
      }
      return .none
      
    case .home:
      return .none
      
    case .record(.backButtonTapped):
      return Effect(value: .setRecordPushed(false))
      
    case .record:
      return .none
      
    case .storage:
      return .none
    }
  }
])
