//
//  SettingView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/05/21.
//

import ComposableArchitecture
import SwiftUI

struct SettingView: View {
  private let store: Store<WithSharedState<SettingState>, SettingAction>

  init(store: Store<WithSharedState<SettingState>, SettingAction>) {
    self.store = store
  }

  var body: some View {
    MSNavigationBar(
      backButtonImage: R.CustomImage.backIcon.image,
      backButtonAction: { ViewStore(store).send(.backButtonTapped) },
      titleText: "설정"
    )
    .padding(.horizontal, 20)
    VStack(spacing: 0) {
      ProfileLinkView(store: store)
      Divider()
        .background(Color.gray8)
      AppInfoLinkView(store: store)
      Divider()
        .background(Color.gray8)
      VersionInfoView(store: store)
      Divider()
        .background(Color.gray8)
    }
    .padding(.top, 24)
    .padding(.horizontal, 20)
    .navigationTitle("")
    .navigationBarHidden(true)
    Spacer()
  }
}

private struct ProfileLinkView: View {
  private let store: Store<WithSharedState<SettingState>, SettingAction>

  init(store: Store<WithSharedState<SettingState>, SettingAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isProfilePushed)) { isProfilePushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.profile,
            action: SettingAction.profile
          ),
          then: ProfileView.init(store:)
        ),
        isActive: isProfilePushedViewStore.binding(
          send: SettingAction.setProfilePushed
        ),
        label: {
          HStack(spacing: 0) {
            Text("계정")
              .padding(.bottom, 15)
              .padding(.top, 15)
              .font(.body2)
              .foregroundColor(.gray2)
            Spacer()
            R.CustomImage.arrowRightIcon.image
          }
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct AppInfoLinkView: View {
  private let store: Store<WithSharedState<SettingState>, SettingAction>

  init(store: Store<WithSharedState<SettingState>, SettingAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isAppInfoPushed)) { isAppInfoPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.appInfo,
            action: SettingAction.appInfo
          ),
          then: AppInfoView.init(store:)
        ),
        isActive: isAppInfoPushedViewStore.binding(
          send: SettingAction.setAppInfoPushed
        ),
        label: {
          HStack {
            Text("정보")
              .padding(.bottom, 15)
              .padding(.top, 15)
              .font(.body2)
              .foregroundColor(.gray2)
            Spacer()
            R.CustomImage.arrowRightIcon.image
          }
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct VersionInfoView: View {
  private let store: Store<WithSharedState<SettingState>, SettingAction>

  init(store: Store<WithSharedState<SettingState>, SettingAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 0) {
        Text("버전 정보")
          .padding(.vertical, 15)
          .font(.body2)
          .foregroundColor(.gray2)
        Spacer()
        Text("1.3")
          .font(.body2)
          .foregroundColor(.gray6)
      }
    }
  }
}
