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

struct ProfileState: Equatable {
  public var userName: String = ""
  public var userEmail: String = ""
  
  // Child State
  public var logoutAlertModal: AlertDoubleButtonState?
  public var withdrawAlertModal: AlertDoubleButtonState?
  
  init(
    logoutAlertModal: AlertDoubleButtonState? = nil,
    witdrawAlertModal: AlertDoubleButtonState? = nil
  ) {
    self.logoutAlertModal = logoutAlertModal
    self.withdrawAlertModal = witdrawAlertModal
  }
}

enum ProfileAction {
  case onAppear
  case backButtonTapped
  case logoutButtonTapped
  case withdrawButtonTapped
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
      
    case .withdrawButtonTapped:
      return setAlertModal(
        state: &state.local.withdrawAlertModal,
        titleText: "정말 몽실을 떠나시겠어요?",
        bodyText: "차곡차곡 쌓은 꿈 일기와\n 저장한 해몽이 모두 사라져요.",
        secondaryButtonTitle: "아니요",
        primaryButtonTitle: "탈퇴하기",
        primaryButtonHierachy: .warning)
      
    case .logoutButtonTapped:
      return setAlertModal(
        state: &state.local.logoutAlertModal,
        titleText: "로그아웃할까요?",
        bodyText: "로그아웃을 해도 꿈일기와\n 저장한 해몽은 사라지지 않아요",
        secondaryButtonTitle: "아니요",
        primaryButtonTitle: "로그아웃",
        primaryButtonHierachy: .warning)
      
    case .logoutAlertModal(.secondaryButtonTapped):
      state.local.logoutAlertModal = nil
      return .none
      
    case .logoutAlertModal(.primaryButtonTapped):
      let window = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }
        .first
      let profile = window?.rootViewController?.children.first as? UINavigationController
      profile?.popToRootViewController(animated: true)
      UserDefaults.standard.removeObject(forKey: "isLogined")
      UserDefaults.standard.bool(forKey: "isKakao") ? requestKakaoLogout() : requestAppleLogout()
      state.local.logoutAlertModal = nil
      return .none
      
    case .withdrawAlertModal(.secondaryButtonTapped):
      state.local.withdrawAlertModal = nil
      return .none
      
    case .withdrawAlertModal(.primaryButtonTapped):
      state.local.withdrawAlertModal = nil
      let window = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .map { $0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter { $0.isKeyWindow }
        .first
      let profile = window?.rootViewController?.children.first as? UINavigationController
      profile?.popToRootViewController(animated: true)
      let userID =  UserDefaults.standard.string(forKey: "userID") ?? ""
      return env.dropoutService.dropout(id: userID)
        .catchToEffect()
        .map ({ result in
          switch result {
          case .success:
            print("회원탈퇴 성공")
            UserDefaults.standard.removeObject(forKey: "userID")
            UserDefaults.standard.removeObject(forKey: "isLogined")
            return .noop
          case let .failure(error):
            print(error)
            return .noop
          }
        })
      
    case .presentToast:
      return .none
      
    case .noop:
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
  UserApi.shared.logout {(error) in
    if let error = error {
      print(error)
    }
    else {
      print("logout success.")
    }
  }
}

private func requestAppleLogout() {
  UserDefaults.standard.removeObject(forKey: "appleName")
  UserDefaults.standard.removeObject(forKey: "appleEmail")
  UserDefaults.standard.removeObject(forKey: "appleUserID")
  UserApi.shared.logout {(error) in
    if let error = error {
      print(error)
    }
    else {
      print("logout success.")
    }
  }
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

