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
  private let colorScheme: ColorScheme

  init(
    store: Store<WithSharedState<AppState>, AppAction>,
    colorScheme: ColorScheme
  ) {
    self.store = store
    self.shouldDisplayRequestAppTrackingAlertViewStore = ViewStore(
      store.scope(state: \.local.shouldDisplayRequestAppTrackingAlert)
    )
    self.colorScheme = colorScheme
  }

  var body: some View {
    ZStack {
      Theme.backgroundColor(scheme: colorScheme)
        .edgesIgnoringSafeArea(.all)

      NavigationView {
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
      .navigationViewStyle(StackNavigationViewStyle())
    }
    .preferredColorScheme(.dark)
  }
}
