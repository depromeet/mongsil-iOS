//
//  ProfileView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/21.
//

import ComposableArchitecture
import SwiftUI

struct ProfileView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>
  
  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }
  
  var body: some View {
    VStack(spacing: 0) {
      MSNavigationBar(
        backButtonImage: R.CustomImage.backIcon.image,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) },
        titleText: "계정"
      )
      .padding(.horizontal, 20)
      UserNameView(store: store)
        .padding(.top, 26)
        .padding(.leading, 20)
      UserEmailView(store: store)
        .padding(.leading, 20)
        .padding(.bottom, 24)
      VStack(alignment: .leading, spacing: 0) {
        LogoutButtonView(store: store)
          .padding(.leading, 20)
          .padding(.vertical, 15)
        Divider()
          .background(Color.gray8)
        WithdrawButtonView(store: store)
          .padding(.leading, 20)
          .padding(.vertical, 15)
        Divider()
          .background(Color.gray8)
      }
      Spacer()
    }
    .alertDoubleButton(
      store: store.scope(
        state: \.local.logoutAlertModal,
        action: ProfileAction.logoutAlertModal
      )
    )
    .alertDoubleButton(
      store: store.scope(
        state: \.local.withdrawAlertModal,
        action: ProfileAction.withdrawAlertModal
      )
    )
    .onAppear(perform: { ViewStore(store).send(.onAppear) })
    .navigationBarHidden(true)
  }
}

private struct UserNameView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>
  
  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }
  
  var body: some View {
    HStack {
      WithViewStore(store.scope(state: \.local.userName)) { userNameViewStore in
        Text("\(userNameViewStore.state)")
          .font(.title2)
          .foregroundColor(.gray2)
        Spacer()
      }
      .padding(.bottom, 8)
      .frame(alignment: .leading)
    }
  }
}

private struct UserEmailView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>
  
  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }
  
  var body: some View {
    HStack {
      WithViewStore(store.scope(state: \.local.userEmail)) { userEmailViewStore in
        Text("\(userEmailViewStore.state)")
          .font(.body2)
          .foregroundColor(.gray6)
        Spacer()
      }
      .frame(alignment: .leading)
    }
  }
}

private struct LogoutButtonView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>
  
  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }
  
  var body: some View {
    Button(action: {
      ViewStore(store).send(.logoutButtonTapped)}) {
        Text("로그아웃")
          .font(.body2)
      }
      .foregroundColor(.gray2)
  }
}

private struct WithdrawButtonView: View {
  private let store: Store<WithSharedState<ProfileState>, ProfileAction>
  
  init(store: Store<WithSharedState<ProfileState>, ProfileAction>) {
    self.store = store
  }
  
  var body: some View {
    Button(action: { ViewStore(store).send(.withdrawButtonTapped) }) {
      Text("탈퇴하기")
        .font(.body2)
    }
    .foregroundColor(.gray2)
  }
}
