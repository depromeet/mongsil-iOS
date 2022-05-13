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
  public var isDiaryPushed: Bool = false
  public var isDreamPushed: Bool = false
  public var userName: String = ""
  public var diaryCount: Int = 0
  public var selectedTab: Tab = .diary
  public var diaryList: [Diary]?
  public var dreamList: [DreamInfo]?
  public var selectedDate: Date = Date()
  public var selectedDateToStr: String {
    return selectedYear+"."+selectedMonth
  }
  public var selectedYear: String
  public var selectedMonth: String
  public var tempYear: String = ""
  public var tempMonth: String = ""
  public var isSelectDateSheetPresented: Bool = false

  // Child State
  public var setting: SettingState?
  public var diary: DiaryState?
  public var dream: DreamState?

  init(
    isSettingPushed: Bool = false,
    isDiaryPushed: Bool = false,
    isDreamPushed: Bool = false,
    selectedTab: Tab = .diary,
    setting: SettingState? = nil,
    diary: DiaryState? = nil,
    dream: DreamState? = nil,
    selectedDate: Date = Date(),
    isSelectDateSheetPresented: Bool = false
  ) {
    self.isSettingPushed = isSettingPushed
    self.isDiaryPushed = isDiaryPushed
    self.isDreamPushed = isDreamPushed
    self.selectedTab = selectedTab
    self.setting = setting
    self.diary = diary
    self.dream = dream
    self.selectedDate = selectedDate
    self.selectedYear = convertYearDateToString(selectedDate)
    self.selectedMonth = convertMonthDateToString(selectedDate)
    self.isSelectDateSheetPresented = isSelectDateSheetPresented
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
  case setDiaryPushed(Bool, Diary? = nil)
  case setDreamPushed(Bool, DreamInfo? = nil)
  case tabTapped(StorageState.Tab)
  case diaryTapped(Diary)
  case dreamTapped(DreamInfo)
  case navigationBarDateButtonTapped
  case setSelectDateSheetPresented(Bool)
  case setSelectedYear(String)
  case setSelectedMonth(String)
  case confirmDateButtonTapped

  // Child Action
  case setting(SettingAction)
  case diary(DiaryAction)
  case dream(DreamAction)
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
  diaryReducer
    .optional()
    .pullback(
      state: \.diary,
      action: /StorageAction.diary,
      environment: { _ in
        DiaryEnvironment()
      }
    ) as Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment>,
  dreamReducer
    .optional()
    .pullback(
      state: \.dream,
      action: /StorageAction.dream,
      environment: { _ in
        DreamEnvironment()
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

    case let .setDiaryPushed(pushed, diary):
      state.local.isDiaryPushed = pushed
      guard let diary = diary else {
        return .none
      }
      if pushed {
        state.local.diary = .init(diary: diary)
      }
      return .none

    case let .setDreamPushed(pushed, dream):
      state.local.isDreamPushed = pushed
      guard let dream = dream else {
        return .none
      }
      if pushed {
        state.local.dream = .init(dream: dream)
      }
      return .none

    case let .tabTapped(tab):
      state.local.selectedTab = tab
      return .none

    case let .diaryTapped(diary):
      return Effect(value: .setDiaryPushed(true, diary))

    case let .dreamTapped(dream):
      return Effect(value: .setDreamPushed(true, dream))

    case .navigationBarDateButtonTapped:
      return Effect(value: .setSelectDateSheetPresented(true))

    case let .setSelectDateSheetPresented(presented):
      state.local.isSelectDateSheetPresented = presented
      return .none

    case let .setSelectedYear(year):
      state.local.tempYear = year
      return .none

    case let .setSelectedMonth(month):
      state.local.tempMonth = month
      return .none

    case .confirmDateButtonTapped:
      if state.local.tempYear != "" {
        state.local.selectedYear = state.local.tempYear
      }
      if state.local.tempMonth != "" {
        state.local.selectedMonth = state.local.tempMonth
      }
      return Effect(value: .setSelectDateSheetPresented(false))

    case .setting(.backButtonTapped):
      return Effect(value: .setSettingPushed(false))

    case .setting:
      return .none

    case .diary(.backButtonTapped):
      return Effect(value: .setDiaryPushed(false))

    case .diary:
      return .none

    case .dream(.backButtonTapped):
      return Effect(value: .setDreamPushed(false))

    case .dream:
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
