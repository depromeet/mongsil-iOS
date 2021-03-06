//
//  AppView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import ComposableArchitecture
import SwiftUI

struct AppView: View {
  private let store: Store<WithSharedState<AppState>, AppAction>
  private let colorScheme: ColorScheme

  init(
    store: Store<WithSharedState<AppState>, AppAction>,
    colorScheme: ColorScheme
  ) {
    self.store = store
    self.colorScheme = colorScheme
  }
  var body: some View {
    ZStack {
      Theme.backgroundColor(scheme: colorScheme)
        .edgesIgnoringSafeArea(.all)
      NavigationView {
        VStack {
          MainTabView(
            store: self.store.scope(
              state: { $0.mainTab },
              action: AppAction.mainTab
            )
          )
        }
        .onAppear(perform: { ViewStore(store).send(.onAppear) })
      }
      .navigationViewStyle(StackNavigationViewStyle())
    }
    .preferredColorScheme(.dark)
    .apply(content: { view in
      WithViewStore(store.scope(state: \.shared.toastText)) { toastTextViewStore in
        view.toast(
          text: toastTextViewStore.state,
          isBottomPosition: ViewStore(store).shared.isToastBottomPosition
        )
      }
    })
  }
}
