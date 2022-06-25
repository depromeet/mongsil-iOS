//
//  SearchResultDetailView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/23.
//

import SwiftUI
import ComposableArchitecture

struct SearchResultDetailView: View {
  private let store: Store<WithSharedState<SearchResultDetailState>, SearchResultDetailAction>
  private let cardResultStore: Store<WithSharedState<CardResultState>, CardResultAction>

  init(store: Store<WithSharedState<SearchResultDetailState>, SearchResultDetailAction>) {
    self.store = store
    self.cardResultStore = self.store.scope(
      state: \.cardResult,
      action: SearchResultDetailAction.cardResult
    )
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.searchResultDetail)) { searchResultDetailViewStore in
      CardResultView(
        store: cardResultStore,
        imageURLs: searchResultDetailViewStore.state?.image ?? [],
        title: searchResultDetailViewStore.state?.title ?? "",
        keywords: searchResultDetailViewStore.state?.categories.map { $0.name } ?? [""],
        description: searchResultDetailViewStore.state?.description ?? "",
        cardResult: .dreamForSave,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )
    }
    .alertDoubleButton(
      store: store.scope(
        state: \.local.alertDoubleButtonAlert,
        action: SearchResultDetailAction.alertDoubleButtonAlert
      )
    )
    .onAppear {
      ViewStore(store).send(.onAppear)
    }
  }
}
