//
//  MainTabCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/08.
//

import Combine
import ComposableArchitecture

struct MainTabState: Equatable {
  public var isRecordPushed: Bool = false
  public var isLoginPushed: Bool = false
  public var requestLoginAlertModal: AlertDoubleButtonState?
  public var selectedTab: Tab = .home
  public var isRecordButtonTapped: Bool = true
  public var isTabBarPresented: Bool = true
  public var isExistStorageTapped: Bool = false

  // Child State
  public var home: HomeState = .init()
  public var record: RecordState?
  public var storage: StorageState = .init()
  public var login: LoginState?

  init(
    isRecordPushed: Bool = false,
    isLoginPushed: Bool = false,
    requestLoginAlertModal: AlertDoubleButtonState? = nil,
    selectedTab: Tab = .home,
    home: HomeState = .init(),
    record: RecordState? = nil,
    storage: StorageState = .init(),
    login: LoginState? = nil,
    isRecordButtonTapped: Bool = true,
    isTabBarPresented: Bool = true,
    isExistStorageTapped: Bool = false
  ) {
    self.isRecordPushed = isRecordPushed
    self.isLoginPushed = isLoginPushed
    self.requestLoginAlertModal = requestLoginAlertModal
    self.selectedTab = selectedTab
    self.home = home
    self.record = record
    self.storage = storage
    self.login = login
    self.isRecordButtonTapped = isRecordButtonTapped
    self.isTabBarPresented = isTabBarPresented
    self.isExistStorageTapped = isExistStorageTapped
  }
}

enum MainTabAction {
  case verifyUserLogined(Bool)
  case setRecordPushed(Bool)
  case setLoginPushed(Bool)
  case tabTapped(MainTabState.Tab)
  case setIsDisplayTabBar(Bool)

  // Child Action
  case home(HomeAction)
  case record(RecordAction)
  case storage(StorageAction)
  case login(LoginAction)
  case requestLoginAlertModal(AlertDoubleButtonAction)
}

struct MainTabEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  var userDreamListService: UserDreamListService
  var dropoutService: DropoutService
  var dreamService: DreamService
  var diaryService: DiaryService

  init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    kakaoLoginService: KakaoLoginService,
    userService: UserService,
    signUpService: SignUpService,
    userDreamListService: UserDreamListService,
    dropoutService: DropoutService,
    dreamService: DreamService,
    diaryService: DiaryService
  ) {
    self.mainQueue = mainQueue
    self.kakaoLoginService = kakaoLoginService
    self.userService = userService
    self.signUpService = signUpService
    self.userDreamListService = userDreamListService
    self.dropoutService = dropoutService
    self.dreamService = dreamService
    self.diaryService = diaryService
  }
}

extension MainTabState {
  public enum Tab: Int, Comparable, Hashable, Identifiable {
    public var id: Int { rawValue }

    case home
    case storage

    public static func < (lhs: Self, rhs: Self) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
}

let mainTabReducer:
Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment> =
Reducer.combine([
  homeReducer
    .pullback(
      state: \.home,
      action: /MainTabAction.home,
      environment: {
        HomeEnvironment(
          mainQueue: $0.mainQueue,
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          dreamService: $0.dreamService,
          diaryService: $0.diaryService,
          userDreamListService: $0.userDreamListService
        )
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  recordReducer
    .optional()
    .pullback(
      state: \.record,
      action: /MainTabAction.record,
      environment: { RecordEnvironment(mainQueue: $0.mainQueue, diaryService: $0.diaryService, dreamService: $0.dreamService) }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  storageReducer
    .pullback(
      state: \.storage,
      action: /MainTabAction.storage,
      environment: {
        StorageEnvironment(
          mainQueue: $0.mainQueue,
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          userDreamListService: $0.userDreamListService,
          dropoutService: $0.dropoutService,
          diaryService: $0.diaryService,
          dreamService: $0.dreamService
        )
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  loginReducer
    .optional()
    .pullback(
      state: \.login,
      action: /MainTabAction.login,
      environment: {
        LoginEnvironment(
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          mainQueue: $0.mainQueue
        )
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.requestLoginAlertModal,
      action: /MainTabAction.requestLoginAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    ) as Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment>,
  Reducer<WithSharedState<MainTabState>, MainTabAction, MainTabEnvironment> {
    state, action, env in
    switch action {
    case let .verifyUserLogined(pushed):
      state.local.isRecordButtonTapped = true
      let isLogined: Bool = UserDefaults.standard.bool(forKey: "isLogined")
      if pushed && !isLogined {
        return setAlertModal(
          state: &state.local.requestLoginAlertModal,
          titleText: "???????????? ????????? ???????????????!",
          bodyText: "??? ????????? ????????? ???????????? ????????????.",
          secondaryButtonTitle: "????????????",
          primaryButtonTitle: "???????????????"
        )
      }
      return Effect(value: .setRecordPushed(pushed))

    case let .setRecordPushed(pushed):
      state.local.isRecordPushed = pushed
      if pushed {
        state.local.record = .init()
      }
      return .none

    case let .setLoginPushed(pushed):
      state.local.isLoginPushed = pushed
      if pushed {
        state.local.login = .init()
      }
      return .none

    case let .tabTapped(tab):
      state.local.isRecordButtonTapped = false
      let isLogined: Bool = UserDefaults.standard.bool(forKey: "isLogined")

      if tab == .storage && !isLogined {
        return setAlertModal(
          state: &state.local.requestLoginAlertModal,
          titleText: "???????????? ????????? ???????????????!",
          bodyText: "???????????? ??????????????? ???????????? ????????????.",
          secondaryButtonTitle: "?????????",
          primaryButtonTitle: "???????????????"
        )
      }
      if tab == .storage && !state.local.isExistStorageTapped {
        state.local.isExistStorageTapped = true
      }
      state.local.selectedTab = tab
      return .none

    case let .setIsDisplayTabBar(isDisplay):
      state.local.isTabBarPresented = isDisplay
      return .none

    case .home(.search(.searchResult(.searchResultDetail(.moveToStorage)))):
      state.local.selectedTab = .storage
      state.local.storage.selectedTab = .dream
      return .none

    case .home(.searchResult(.searchResultDetail(.moveToStorage))):
      state.local.selectedTab = .storage
      state.local.storage.selectedTab = .dream
      return .none

    case .storage(.diary(.searchResult(.searchResultDetail(.moveToStorage)))):
      state.local.selectedTab = .storage
      state.local.storage.selectedTab = .dream
      return .none

    case .storage(.diary(.search(.searchResult(.searchResultDetail(.moveToStorage))))):
      state.local.selectedTab = .storage
      state.local.storage.selectedTab = .dream
      return .none

    case .home:
      return .none

    case .record(.backButtonTapped):
      return Effect(value: .setRecordPushed(false))

    case let .record(.recordKeyword(.moveToDiaryView(diary))):
      guard let diary = diary else {
        return Effect.concatenate([
          Effect(value: .setRecordPushed(false)),
          Effect(value: .tabTapped(.storage)),
          Effect(value: .storage(.presentToast("????????? ?????? ??? ????????????.")))
        ])
      }

      if state.local.isExistStorageTapped {
        return Effect.concatenate([
          Effect(value: .setRecordPushed(false)),
          Effect(value: .tabTapped(.storage)),
          Effect(value: .storage(.setDiaryPushed(true, diary)))
        ])
      }

      return Effect.concatenate([
        Effect(value: .setRecordPushed(false)),
        Effect(value: .tabTapped(.storage)),
        Effect(value: .storage(.setDiaryPushed(true, diary)))
          .delay(for: 1, scheduler: env.mainQueue)
          .eraseToEffect()
      ])

    case .record:
      return .none

    case let .storage(.setSelectDateSheetPresented(presented)):
      return Effect(value: .setIsDisplayTabBar(!presented))

    case .storage:
      return .none

    case .login(.backButtonTapped):
      return Effect(value: .setLoginPushed(false))

    case .login(.loginCompleted):
      if state.local.isRecordButtonTapped {
        return Effect.concatenate([
          Effect(value: .setLoginPushed(false)),
          Effect(value: .setRecordPushed(true))
            .delay(for: .milliseconds(1000), scheduler: env.mainQueue)
            .eraseToEffect()
        ])
      }
      state.local.selectedTab = .storage
      return Effect(value: .setLoginPushed(false))

    case .login:
      return .none

    case .requestLoginAlertModal(.primaryButtonTapped):
      state.local.requestLoginAlertModal = nil
      return Effect(value: .setLoginPushed(true))

    case .requestLoginAlertModal(.secondaryButtonTapped):
      state.local.requestLoginAlertModal = nil
      return .none

    case .requestLoginAlertModal:
      return .none
    }
  }
])

private func setAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy = .primary
) -> Effect<MainTabAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
