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
  public var userName: String = ""
  public var diaryCount: Int = 0
  public var selectedTab: Tab = .diary
  public var diaryList: [Diary]?
  public var dreamList: [DreamInfo]?

  // Child State
  public var setting: SettingState?

  init(
    isSettingPushed: Bool = false,
    selectedTab: Tab = .diary
  ) {
    self.isSettingPushed = isSettingPushed
    self.selectedTab = selectedTab
  }
}

extension StorageState {
  public enum Tab: Int, Comparable, Hashable, Identifiable {
    public var id: Int { rawValue }

    case diary
    case dream

    public static func < (lhs: Self, rhs: Self) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
}

enum StorageAction {
  case onAppear
  case setSettingPushed(Bool)
  case tabTapped(StorageState.Tab)
  case diaryTapped
  case dreamTapped

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
    case .onAppear:
      return Effect.concatenate([
        setUserName(state: &state),
        setDiaryList(state: &state),
        setDreamList(state: &state),
        setDiaryCount(state: &state)
      ])

    case let .setSettingPushed(pushed):
      state.local.isSettingPushed = pushed
      if pushed {
        state.local.setting = .init()
      }
      return .none

    case let .tabTapped(tab):
      state.local.selectedTab = tab
      return .none

    case .diaryTapped:
      return .none

    case .dreamTapped:
      return .none

    case .setting(.backButtonTapped):
      return Effect(value: .setSettingPushed(false))

    case .setting:
      return .none
    }
  }
])

private func setUserName(state: inout WithSharedState<StorageState>) -> Effect<StorageAction, Never> {
  if UserDefaults.standard.bool(forKey: "isKakao") {
    state.local.userName = UserDefaults.standard.string(forKey: "kakaoName") ?? ""
  } else {
    state.local.userName = UserDefaults.standard.string(forKey: "appleName") ?? ""
  }
  return .none
}

private func setDiaryList(state: inout WithSharedState<StorageState>) -> Effect<StorageAction, Never> {
  // 추후 유저가 저장한 꿈일기에 대해 받아오는 API 및 로직 필요
  state.local.diaryList = Diary.Stub.diaryList
  return .none
}

private func setDreamList(state: inout WithSharedState<StorageState>) -> Effect<StorageAction, Never> {
  // 추후 유저가 저장한 해몽에 대해 받아오는 API 및 로직 필요
  state.local.dreamList = Dream.Stub.dream1.subcategory[0].dreamInfo
  return .none
}

private func setDiaryCount(state: inout WithSharedState<StorageState>) -> Effect<StorageAction, Never> {
  let diaryCount = state.local.diaryList?.count
  state.local.diaryCount = diaryCount ?? 0
  return .none
}
