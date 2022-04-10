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
  private let shouldDisplayRequestAppTrackingAlertViewStore: ViewStore<Bool, AppAction>

  init(store: Store<WithSharedState<AppState>, AppAction>) {
    self.store = store
    self.shouldDisplayRequestAppTrackingAlertViewStore = ViewStore(
      store.scope(state: \.local.shouldDisplayRequestAppTrackingAlert)
    )
  }

  var body: some View {
    VStack {
      HomeView(
        store: self.store.scope(
          state: { $0.home },
          action: AppAction.home
        )
      )
        .onReceive(
          shouldDisplayRequestAppTrackingAlertViewStore.publisher,
          perform: { display in
            if display {
              ViewStore(store).send(.displayRequestAppTrackingAlert)
            }
          }
        )
    }
    .onAppear(perform: { ViewStore(store).send(.onAppear) })
  }
}
