//
//  StorageView.swift
//  Mongsil
//
//  Created by 이승후 on 2022/04/08.
//

import SwiftUI
import ComposableArchitecture

struct StorageView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    VStack {
      StorageNavigationView(store: store)
      Spacer()
      Text("StoreView")
      Spacer()
    }
    .navigationTitle("")
    .navigationBarHidden(true)
  }
}

private struct StorageNavigationView: View {
  private let store: Store<WithSharedState<StorageState>, StorageAction>

  init(store: Store<WithSharedState<StorageState>, StorageAction>) {
    self.store = store
  }

  var body: some View {
    ZStack {
      MSNavigationBar(
        titleText: "보관함",
        isUseBackButton: false
      )
      HStack {
        Spacer()
        WithViewStore(store.scope(state: \.local.isSettingPushed)) { isSettingPushedViewStore in
          NavigationLink(
            destination: IfLetStore(
              store.scope(
                state: \.setting,
                action: StorageAction.setting
              ),
              then: SettingView.init(store: )
            ),
            isActive: isSettingPushedViewStore.binding(
              send: StorageAction.setSettingPushed
            ),
            label: {
              R.CustomImage.settingIcon.image
            }
          )
          .isDetailLink(true)
          .padding(.trailing, 20)
        }
      }
    }
  }
}
