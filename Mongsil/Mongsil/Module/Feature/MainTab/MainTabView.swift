//
//  MainTabView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/10.
//

import SwiftUI
import ComposableArchitecture

struct MainTabView: View {
  private let store: Store<WithSharedState<MainTabState>, MainTabAction>

  init(store: Store<WithSharedState<MainTabState>, MainTabAction>) {
    self.store = store
    UITabBar.appearance().scrollEdgeAppearance = .init()
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.selectedTab)) { selectedTabViewStore in
      GeometryReader { metrics in
        MSTabView<MainTabState.Tab>(
          activeIcons: [
            .home: R.CustomImage.homeActiveIcon.image,
            .storage: R.CustomImage.storageActiveIcon.image
          ],
          disabledIcons: [
            .home: R.CustomImage.homeDisabledIcon.image,
            .storage: R.CustomImage.storageDisabledIcon.image
          ],
          views: [
            .home: HomeView(
              store: store.scope(state: \.home, action: MainTabAction.home)
            ).eraseToAnyView(),
            .storage: StorageView(
              store: store.scope(state: \.storage, action: MainTabAction.storage)
            ).eraseToAnyView()
          ],
          selection: selectedTabViewStore.binding(
            get: { $0 },
            send: MainTabAction.tabTapped
          )
        )
        RecordButtonView(store: store)
          .offset(x: metrics.size.width/2 - 33, y: metrics.size.height - 89)
      }
      .backgroundIf(
        selectedTabViewStore.state == .home,
        R.CustomImage.backgroundImage2.image
          .resizable()
          .ignoresSafeArea(.all)
      )
    }
    .ignoresSafeArea(.keyboard)
    .alertDoubleButton(
      store: store.scope(
        state: \.local.requestLoginAlertModal,
        action: MainTabAction.requestLoginAlertModal
      )
    )
  }
}

private struct RecordButtonView: View {
  private let store: Store<WithSharedState<MainTabState>, MainTabAction>

  init(store: Store<WithSharedState<MainTabState>, MainTabAction>) {
    self.store = store
  }

  var body: some View {
    RecordLink(store: store)
    LoginLink(store: store)

  }
}

private struct RecordLink: View {
  private let store: Store<WithSharedState<MainTabState>, MainTabAction>

  init(store: Store<WithSharedState<MainTabState>, MainTabAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isRecordPushed)) { isRecordPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.record,
            action: MainTabAction.record
          ),
          then: RecordView.init(store: )
        ),
        isActive: isRecordPushedViewStore.binding(
          send: MainTabAction.setRecordPushed
        ),
        label: {
          EmptyView()
        }
      )
      .isDetailLink(true)
    }
  }
}

private struct LoginLink: View {
  private let store: Store<WithSharedState<MainTabState>, MainTabAction>

  init(store: Store<WithSharedState<MainTabState>, MainTabAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.isLoginPushed)) { isLoginPushedViewStore in
      NavigationLink(
        destination: IfLetStore(
          store.scope(
            state: \.login,
            action: MainTabAction.login
          ),
          then: LoginView.init(store: )
        ),
        isActive: isLoginPushedViewStore.binding(
          send: MainTabAction.verifyUserLogined
        ),
        label: {
          R.CustomImage.recordIcon.image
        }
      )
      .isDetailLink(true)
    }
  }
}
