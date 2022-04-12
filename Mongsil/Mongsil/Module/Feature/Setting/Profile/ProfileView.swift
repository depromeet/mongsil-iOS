//
//  ProfileView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>

  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }

  var body: some View {
    VStack {
      MSNavigationBar(
        titleText: "계정",
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )
      UserInfoView(store: store)
      Spacer()
        .frame(height: 50)
      VStack(spacing: 10) {
        LogoutButtonView(store: store)
        WithdrawButtonView(store: store)
      }
      Spacer()
    }
    .navigationBarHidden(true)
  }
}

private struct UserInfoView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>

  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }

  var body: some View {
    HStack(spacing: 20) {
      Circle()
        .fill(.gray)
        .frame(width: 50, height: 50)
      VStack(alignment: .leading, spacing: 10) {
        Text("사용자 이름")
        Text("연동된 이메일 주소@email.com")
      }
      Spacer()
    }
  }
}

private struct LogoutButtonView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>

  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }

  var body: some View {
    ListButtonItemWithText(
      buttonAction: { ViewStore(store).send(.logoutButtonTapped) },
      content: {
        Text("로그아웃")
          .foregroundColor(.gray2)
      }
    )
  }
}

private struct WithdrawButtonView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>

  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }

  var body: some View {
    ListButtonItemWithText(
      buttonAction: { ViewStore(store).send(.withdrawButtonTapped) },
      content: {
        Text("탈퇴하기")
          .foregroundColor(.gray2)
      }
    )
  }
}
