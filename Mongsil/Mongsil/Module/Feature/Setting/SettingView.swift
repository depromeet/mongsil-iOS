//
//  SettingView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/11.
//

import ComposableArchitecture
import SwiftUI

struct SettingView: View {
  private let store: Store<WithSharedState<SettingState>, SettingAction>

  init(store: Store<WithSharedState<SettingState>, SettingAction>) {
    self.store = store
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      MSNavigationBar(
        backButtonImage: R.CustomImage.backIcon.image,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) },
        titleText: "설정"
      )
      ProfileButtonView(store: store)
      AppInfoButtonView(store: store)
      VersionInfoView(store: store)

      Spacer()
    }
    .padding(.horizontal, 20)
    .navigationBarHidden(true)
  }
}

private struct ProfileButtonView: View {
  private let store: Store<WithSharedState<SettingState>, SettingAction>

  init(store: Store<WithSharedState<SettingState>, SettingAction>) {
    self.store = store
  }

  var body: some View {
    ListItemWithTextIcon(
      content: { ProfileLink(store: store) }
    )
  }
}

private struct ProfileLink: View {
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
          Text("계정")
            .font(.title2)
            .foregroundColor(.gray2)
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct AppInfoButtonView: View {
  private let store: Store<WithSharedState<SettingState>, SettingAction>

  init(store: Store<WithSharedState<SettingState>, SettingAction>) {
    self.store = store
  }

  var body: some View {
    ListItemWithTextIcon(
      content: { AppInfoLink(store: store) }
    )
  }
}

private struct AppInfoLink: View {
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
          Text("정보")
            .font(.title2)
            .foregroundColor(.gray2)
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
    ListItemWithText(
      content: {
        Text("버전 정보")
          .font(.title2)
          .foregroundColor(.gray2)
        Spacer()
        Text("1.0")
          .font(.title3)
          .foregroundColor(.gray2)
      }
    )
  }
}
