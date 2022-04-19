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
    GeometryReader { metrics in
      TabView {
        HomeTabView(store: store)
        StoreTabView(store: store)
      }
      RecordButtonView(store: store)
        .offset(x: metrics.size.width/2.3, y: metrics.size.height/1.105)
    }
  }
}

private struct HomeTabView: View {
  private let store: Store<WithSharedState<MainTabState>, MainTabAction>

  init(store: Store<WithSharedState<MainTabState>, MainTabAction>) {
    self.store = store
  }

  var body: some View {
    HomeView(
      store: store.scope(
        state: \.home,
        action: MainTabAction.home
      )
    )
    .tabItem {
      Image(systemName: "square.fill")
        .font(.title)
      Text("홈")
    }
  }
}

private struct StoreTabView: View {
  private let store: Store<WithSharedState<MainTabState>, MainTabAction>

  init(store: Store<WithSharedState<MainTabState>, MainTabAction>) {
    self.store = store
  }

  var body: some View {
    StorageView(
      store: store.scope(
        state: \.store,
        action: MainTabAction.store
      )
    )
    .tabItem {
      Image(systemName: "square.fill")
        .font(.title)
      Text("보관함")
    }
  }
}

private struct RecordButtonView: View {
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
          Image(systemName: "circle.fill")
            .font(.largeTitle)
            .frame(width: 48, height: 48, alignment: .center)
            .cornerRadius(28)
            .foregroundColor(.gray)
        }
      )
      .isDetailLink(true)
    }
  }
}
