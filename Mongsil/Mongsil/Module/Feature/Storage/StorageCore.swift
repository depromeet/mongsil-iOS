//
//  StorageCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/08.
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
  public var displayNavigationTitle: Bool {
    selectedTab == .diary
  }
  public var diaryList: [Diary]?
  public var diaryListWithDate: [Diary] {
    diaryList?.filter {
      $0.convertedDate.contains(self.selectedDateToStr)
    } ?? []
  }
  public var userDreamList: [UserDream]?
  public var selectedDate: Date = Date()
  public var selectedDateToStr: String {
    return selectedYear+"."+selectedMonth
  }
  public var selectedYear: String
  public var selectedMonth: String
  public var tempYear: String = ""
  public var tempMonth: String = ""
  public var isSelectDateSheetPresented: Bool = false
  public var displayDeleteCardHeader: Bool = false
  public var deleteDiaryList: [Diary] = []
  public var deleteUserDreamList: [UserDream] = []
  public var selectedDeleteCardCount: Int {
    selectedTab == .diary
    ? deleteDiaryList.count
    : deleteUserDreamList.count
  }

  // Child State
  public var setting: SettingState?
  public var diary: DiaryState?
  public var dream: DreamState?
  public var deleteCardAlertModal: AlertDoubleButtonState?

  init(
    isSettingPushed: Bool = false,
    isDiaryPushed: Bool = false,
    isDreamPushed: Bool = false,
    selectedTab: Tab = .diary,
    setting: SettingState? = nil,
    diary: DiaryState? = nil,
    dream: DreamState? = nil,
    selectedDate: Date = Date(),
    isSelectDateSheetPresented: Bool = false,
    displayDeleteCardHeader: Bool = false,
    deleteDiaryList: [Diary] = [],
    deleteUserDreamList: [UserDream] = [],
    deleteCardAlertModal: AlertDoubleButtonState? = nil
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
    self.displayDeleteCardHeader = displayDeleteCardHeader
    self.deleteDiaryList = deleteDiaryList
    self.deleteUserDreamList = deleteUserDreamList
    self.deleteCardAlertModal = deleteCardAlertModal
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

enum StorageAction: ToastPresentableAction {
  case onAppear
  case setUserDreamList([UserDream])
  case setUserDiaryList([Diary])
  case setSettingPushed(Bool)
  case setDiaryPushed(Bool, Diary? = nil)
  case setDreamPushed(Bool, UserDream? = nil)
  case tabTapped(StorageState.Tab)
  case diaryTapped(Diary)
  case dreamTapped(UserDream)
  case navigationBarDateButtonTapped
  case setSelectDateSheetPresented(Bool)
  case setSelectedYear(String)
  case setSelectedMonth(String)
  case confirmDateButtonTapped
  case setDisplayDeleteCardHeader(Bool)
  case completeButtonTapped(StorageState.Tab)
  case clearSelectionButtonTapped(StorageState.Tab)
  case deleteButtonTapped(StorageState.Tab)
  case setDeleteDiaryList
  case setDeleteUserDreamList
  case presentToast(String)
  case noop

  // Child Action
  case setting(SettingAction)
  case diary(DiaryAction)
  case dream(DreamAction)
  case deleteCardAlertModal(AlertDoubleButtonAction)
}

struct StorageEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  var userDreamListService: UserDreamListService
  var dropoutService: DropoutService
  var diaryService: DiaryService
  var dreamService: DreamService
}

let storageReducer: Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment> =
Reducer.combine([
  settingReducer
    .optional()
    .pullback(
      state: \.setting,
      action: /StorageAction.setting,
      environment: {
        SettingEnvironment(dropoutService: $0.dropoutService)
      }
    ) as Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment>,
  diaryReducer
    .optional()
    .pullback(
      state: \.diary,
      action: /StorageAction.diary,
      environment: {
        DiaryEnvironment(
          mainQueue: $0.mainQueue,
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          diaryService: $0.diaryService,
          dreamService: $0.dreamService,
          userDreamListService: $0.userDreamListService
        )
      }
    ) as Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment>,
  dreamReducer
    .optional()
    .pullback(
      state: \.dream,
      action: /StorageAction.dream,
      environment: {
        DreamEnvironment(
          mainQueue: $0.mainQueue,
          userDreamListService: $0.userDreamListService,
          diaryService: $0.diaryService,
          dreamService: $0.dreamService
        )
      }
    ) as Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment>,
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.deleteCardAlertModal,
      action: /StorageAction.deleteCardAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    ) as Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment>,
  Reducer<WithSharedState<StorageState>, StorageAction, StorageEnvironment> {
    state, action, env in
    switch action {
    case .onAppear:
      return Effect.concatenate([
        setUserName(state: &state),
        setDreamList(state: &state, env: env),
        setDiaryList(state: &state, env: env)
      ])

    case let .setUserDreamList(userDreamList):
      state.local.userDreamList = userDreamList
      return .none

    case let .setUserDiaryList(diaryList):
      state.local.diaryList = diaryList
      return setDiaryCount(state: &state)

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
        state.local.diary = .init(userDiary: diary)
      }
      return .none

    case let .setDreamPushed(pushed, dream):
      state.local.isDreamPushed = pushed
      guard let dream = dream else {
        return .none
      }
      if pushed {
        state.local.dream = .init(userDreamCardResult: .init(userDream: dream))
      }
      return .none

    case let .tabTapped(tab):
      if state.local.selectedTab != tab {
        state.local.selectedTab = tab
        return Effect(value: .setDisplayDeleteCardHeader(false))
      }
      return .none

    case let .diaryTapped(diary):
      if state.local.displayDeleteCardHeader {
        if state.local.deleteDiaryList.contains(diary) {
          state.local.deleteDiaryList.remove(object: diary)
        } else {
          state.local.deleteDiaryList.append(diary)
        }
        return .none
      }
      return Effect(value: .setDiaryPushed(true, diary))

    case let .dreamTapped(dream):
      if state.local.displayDeleteCardHeader {
        if state.local.deleteUserDreamList.contains(dream) {
          state.local.deleteUserDreamList.remove(object: dream)
        } else {
          state.local.deleteUserDreamList.append(dream)
        }
        return .none
      }
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
      return Effect.merge([
        Effect(value: .setSelectDateSheetPresented(false)),
        setDiaryCount(state: &state)
      ])

    case let .setDisplayDeleteCardHeader(display):
      if !display {
        state.local.deleteDiaryList.removeAll()
        state.local.deleteUserDreamList.removeAll()
      }
      state.local.displayDeleteCardHeader = display
      return setDiaryCount(state: &state)

    case let .completeButtonTapped(tab):
      switch tab {
      case .diary:
        return Effect.concatenate([
          revortDeleteList(of: .diary, state: &state),
          Effect(value: .setDisplayDeleteCardHeader(false))
        ])
      case .dream:
        return Effect.concatenate([
          revortDeleteList(of: .dream, state: &state),
          Effect(value: .setDisplayDeleteCardHeader(false))
        ])
      }

    case let .clearSelectionButtonTapped(tab):
      switch tab {
      case .diary:
        return revortDeleteList(of: .diary, state: &state)
      case .dream:
        return revortDeleteList(of: .dream, state: &state)
      }

    case let .deleteButtonTapped(tab):
      switch tab {
      case .diary:
        return setAlertModal(
          state: &state.local.deleteCardAlertModal,
          titleText: "??? ????????? ????????????????",
          bodyText: "???????????? ?????? ????????? ??? ?????????.",
          secondaryButtonTitle: "?????????",
          primaryButtonTitle: "????????????"
        )
      case .dream:
        return setAlertModal(
          state: &state.local.deleteCardAlertModal,
          titleText: "????????? ????????????????",
          bodyText: "???????????? ?????? ???????????? ????????? ??? ?????????.",
          secondaryButtonTitle: "?????????",
          primaryButtonTitle: "????????????"
        )
      }

    case .setDeleteDiaryList:
      for diary in state.local.deleteDiaryList {
        state.local.diaryList?.remove(object: diary)
      }
      state.local.deleteDiaryList.removeAll()
      return .none

    case .setDeleteUserDreamList:
      for dream in state.local.deleteUserDreamList {
        state.local.userDreamList?.remove(object: dream)
      }
      state.local.deleteUserDreamList.removeAll()
      return .none

    case .presentToast:
      return .none

    case .noop:
      return .none

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

    case .deleteCardAlertModal(.primaryButtonTapped):
      state.local.deleteCardAlertModal = nil
      if state.local.selectedTab == .diary {
        return Effect.concatenate([
          deleteDiaryList(state: &state, env: env),
          setDiaryCount(state: &state),
          Effect(value: .setDisplayDeleteCardHeader(false))
        ])
      } else {
        return Effect.concatenate([
          deleteDreamList(state: &state, env: env),
          Effect(value: .setDisplayDeleteCardHeader(false))
        ])
      }

    case .deleteCardAlertModal(.secondaryButtonTapped):
      state.local.deleteCardAlertModal = nil
      return .none

    case .deleteCardAlertModal:
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

private func setDiaryList(
  state: inout WithSharedState<StorageState>,
  env: StorageEnvironment
) -> Effect<StorageAction, Never> {
  guard let userID = state.shared.userID else {
    return .none
  }

  return env.diaryService.getDiaryList(userID: userID)
    .catchToEffect()
    .map({ result in
      switch result {
      case let .success(response):
        return StorageAction.setUserDiaryList(response.cardList)
      case .failure:
        return StorageAction.noop
      }
    })
}

private func setDreamList(
  state: inout WithSharedState<StorageState>,
  env: StorageEnvironment
) -> Effect<StorageAction, Never> {
  guard let userID = state.shared.userID else {
    return .none
  }

  return env.userDreamListService.getUserDreamList(userID: userID)
    .catchToEffect()
    .map({ result in
      switch result {
      case let .success(response):
        return StorageAction.setUserDreamList(response.dreamList)
      case .failure:
        return StorageAction.noop
      }
    })
}

private func setDiaryCount(state: inout WithSharedState<StorageState>) -> Effect<StorageAction, Never> {
  let diaryCount = state.local.diaryListWithDate.count
  state.local.diaryCount = diaryCount
  return .none
}

private func deleteDiaryList(
  state: inout WithSharedState<StorageState>,
  env: StorageEnvironment
) -> Effect<StorageAction, Never> {
  let deleteDiaryIDList = state.local.deleteDiaryList
    .map({ $0.id })

  return env.diaryService.deleteDiary(idList: deleteDiaryIDList)
    .catchToEffect()
    .map({ result in
      switch result {
      case .success:
        return StorageAction.setDeleteDiaryList
      case .failure:
        return StorageAction.presentToast("??? ????????? ???????????? ????????????. ?????? ??????????????????.")
      }
    })
}

private func deleteDreamList(
  state: inout WithSharedState<StorageState>,
  env: StorageEnvironment
) -> Effect<StorageAction, Never> {
  let deleteUserDreamListID = state.local.deleteUserDreamList
    .map({ $0.id })
  return env.userDreamListService.deleteUserDreamList(dreamIDs: deleteUserDreamListID)
    .catchToEffect()
    .map({ result in
      switch result {
      case .success:
        return StorageAction.setDeleteUserDreamList
      case .failure:
        return StorageAction.presentToast("????????? ???????????? ????????????. ?????? ??????????????????.")
      }
    })
}

private func revortDeleteList(
  of tab: StorageState.Tab,
  state: inout WithSharedState<StorageState>
) -> Effect<StorageAction, Never> {
  switch tab {
  case .diary:
    state.local.deleteDiaryList.removeAll()
  case .dream:
    state.local.deleteUserDreamList.removeAll()
  }
  return .none
}

private func setAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy = .warning
) -> Effect<StorageAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
