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
  public var isLoginPushed: Bool = false
  public var requestLoginAlertModal: AlertDoubleButtonState?

  // Child State
  public var home: HomeState = .init()
  public var record: RecordState?
  public var storage: StorageState = .init()
  public var login: LoginState?

  init(
    isRecordPushed: Bool = false,
    isLoginPushed: Bool = false,
    requestLoginAlertModal: AlertDoubleButtonState? = nil
  ) {
    self.isRecordPushed = isRecordPushed
    self.isLoginPushed = isLoginPushed
    self.requestLoginAlertModal = requestLoginAlertModal
  }
}

enum MainTabAction {
  case verifyUserLogined(Bool)
  case setRecordPushed(Bool)
  case setLoginPushed(Bool)

  // Child Action
  case home(HomeAction)
  case record(RecordAction)
  case storage(StorageAction)
  case login(LoginAction)
  case requestLoginAlertModal(AlertDoubleButtonAction)
}

struct MainTabEnvironment {
  var mainQueue: AnySchedulerOf<DispatchQueue>

  init(
    mainQueue: AnySchedulerOf<DispatchQueue>
  ) {
    self.mainQueue = mainQueue
  }
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
  loginReducer
    .optional()
    .pullback(
      state: \.login,
      action: /MainTabAction.login,
      environment: { _ in
        LoginEnvironment()
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
    state, action, _ in
    switch action {
    case let .verifyUserLogined(logined):
      // 기존 로그인 연동 이력 검증
      if logined {
        // False
        return setAlertModal(
          state: &state.local.requestLoginAlertModal,
          titleText: "로그인이 필요한 기능이에요!",
          bodyText: "꿈 일기를 쓰려면\n로그인을 해주세요.",
          secondaryButtonTitle: "아니요",
          primaryButtonTitle: "로그인하기"
        )
      }
      // True
      return Effect(value: .setRecordPushed(logined))

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

    case .home:
      return .none

    case .record(.backButtonTapped):
      return Effect(value: .setRecordPushed(false))

    case .record:
      return .none

    case .storage:
      return .none

    case .login(.backButtonTapped):
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
  primaryButtonTitle: String
) -> Effect<MainTabAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    primaryButtonTitle: primaryButtonTitle
  )
  return .none
}
