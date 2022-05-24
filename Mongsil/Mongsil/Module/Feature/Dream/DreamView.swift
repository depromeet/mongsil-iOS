//
//  DreamView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/11.
//

import SwiftUI
import ComposableArchitecture

struct DreamView: View {
  private let store: Store<WithSharedState<DreamState>, DreamAction>
  private let cardResultStore: Store<WithSharedState<CardResultState>, CardResultAction>

  init(store: Store<WithSharedState<DreamState>, DreamAction>) {
    self.store = store
    self.cardResultStore = self.store.scope(
      state: \.cardResult,
      action: DreamAction.cardResult
    )
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.userDreamCardResult)) { userDreamCardResultViewStore in
      CardResultView(
        store: cardResultStore,
        imageURLs: userDreamCardResultViewStore.state.imageURLs,
        title: userDreamCardResultViewStore.state.userDream.title,
        keywords: userDreamCardResultViewStore.state.keywords,
        description: userDreamCardResultViewStore.state.userDream.description,
        cardResult: .dreamForDelete,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )
    }
    .alertDoubleButton(
      store: store.scope(
        state: \.local.requestDeleteDreamAlertModal,
        action: DreamAction.requestDeleteDreamAlertModal
      )
    )
    .alertDoubleButton(
      store: store.scope(
        state: \.local.requestSaveDreamAlertModal,
        action: DreamAction.requestSaveDreamAlertModal
      )
    )
  }
}
