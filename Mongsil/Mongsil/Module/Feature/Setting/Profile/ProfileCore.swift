//
//  ProfileCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import ComposableArchitecture
import KakaoSDKUser
import KakaoSDKAuth
import SwiftUI
import Combine

struct ProfileState: Equatable {
  public var userName: String = ""
  public var userEmail: String = ""

  // Child State
  public var logoutAlertModal: AlertDoubleButtonState?
  public var withdrawAlertModal: AlertDoubleButtonState?

  init(
    logoutAlertModal: AlertDoubleButtonState? = nil,
    withdrawAlertModal: AlertDoubleButtonState? = nil
  ) {
    self.logoutAlertModal = logoutAlertModal
    self.withdrawAlertModal = withdrawAlertModal
  }
}

enum ProfileAction {
  case onAppear
  case backButtonTapped
  case logoutButtonTapped
  case withdrawButtonTapped
  case setUserID(String?)
  case presentToast(String)
  case noop

  // Child Action
  case logoutAlertModal(AlertDoubleButtonAction)
  case withdrawAlertModal(AlertDoubleButtonAction)
}

struct ProfileEnvironment {
  var dropoutService: DropoutService
}

let profileReducer: Reducer<WithSharedState<ProfileState>, ProfileAction, ProfileEnvironment> =
Reducer.combine([
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.logoutAlertModal,
      action: /ProfileAction.logoutAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    )
  as Reducer<WithSharedState<ProfileState>, ProfileAction, ProfileEnvironment>,
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.withdrawAlertModal,
      action: /ProfileAction.withdrawAlertModal,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    )
  as Reducer<WithSharedState<ProfileState>, ProfileAction, ProfileEnvironment>,
  Reducer<WithSharedState<ProfileState>, ProfileAction, ProfileEnvironment> {
    state, action, env in
    switch action {
    case .onAppear:
      return Effect.concatenate([
        setUserName(state: &state),
        setUserEmail(state: &state)
      ])

    case .backButtonTapped:
      return .none

    case .logoutButtonTapped:
      return setAlertModal(
        state: &state.local.logoutAlertModal,
        titleText: "??????????????????????",
        bodyText: "??????????????? ?????? ??? ?????????\n ????????? ????????? ???????????? ?????????",
        secondaryButtonTitle: "?????????",
        primaryButtonTitle: "????????????",
        primaryButtonHierachy: .warning
      )

    case .withdrawButtonTapped:
      return setAlertModal(
        state: &state.local.withdrawAlertModal,
        titleText: "?????? ????????? ???????????????????",
        bodyText: "???????????? ?????? ??? ?????????\n ????????? ????????? ?????? ????????????.",
        secondaryButtonTitle: "?????????",
        primaryButtonTitle: "????????????",
        primaryButtonHierachy: .warning
      )

    case .logoutAlertModal(.secondaryButtonTapped):
      state.local.logoutAlertModal = nil
      return .none

    case .logoutAlertModal(.primaryButtonTapped):
      UserDefaults.standard.removeObject(forKey: "isLogined")
      UserDefaults.standard.bool(forKey: "isKakao") ? requestKakaoLogout() : requestAppleLogout()
      state.local.logoutAlertModal = nil
      popToRoot()
      return .none

    case .withdrawAlertModal(.secondaryButtonTapped):
      state.local.withdrawAlertModal = nil
      return .none

    case .withdrawAlertModal(.primaryButtonTapped):
      state.local.withdrawAlertModal = nil
      return env.dropoutService.dropout(id: state.shared.userID ?? "")
        .catchToEffect()
        .flatMapLatest({ result -> Effect<ProfileAction, Never> in
          switch result {
          case .success:
            UserApi.shared.unlink {(error) in
              if let error = error {
                print(error)
              } else {
                print("token deleted")
              }
            }
            UserDefaults.standard.removeObject(forKey: "isLogined")
            return Effect(value: .setUserID(nil))

          case .failure:
            return Effect(value: .presentToast("?????? ????????? ???????????????. ?????? ??????????????????."))
          }
        })
        .eraseToEffect()

    case .presentToast:
      return .none

    case .noop:
      return .none

    case let .setUserID(userID):
      return .none

    case .logoutAlertModal(.closeButtonTapped):
      return .none

    case .withdrawAlertModal(.closeButtonTapped):
      return .none
    }
  }
])

private func setUserName(state: inout WithSharedState<ProfileState>) -> Effect<ProfileAction, Never> {
  if UserDefaults.standard.bool(forKey: "isKakao") {
    state.local.userName = UserDefaults.standard.string(forKey: "kakaoName") ?? ""
  } else {
    state.local.userName = UserDefaults.standard.string(forKey: "appleName") ?? ""
  }
  return .none
}

private func setUserEmail(state: inout WithSharedState<ProfileState>) -> Effect<ProfileAction, Never> {
  if UserDefaults.standard.bool(forKey: "isKakao") {
    state.local.userEmail = UserDefaults.standard.string(forKey: "kakaoEmail") ?? ""
  } else {
    state.local.userEmail = UserDefaults.standard.string(forKey: "appleEmail") ?? ""
  }
  return .none
}

private func requestKakaoLogout() {
  UserDefaults.standard.removeObject(forKey: "kakaoName")
  UserDefaults.standard.removeObject(forKey: "kakaoEmail")
  UserDefaults.standard.removeObject(forKey: "isKakao")
}

private func requestAppleLogout() {
  UserDefaults.standard.removeObject(forKey: "isKakao")
}

private func setAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy
) -> Effect<ProfileAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
