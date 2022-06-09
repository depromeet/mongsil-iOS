//
//  DiaryView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/11.
//

import SwiftUI
import ComposableArchitecture

struct DiaryView: View {
  private let store: Store<WithSharedState<DiaryState>, DiaryAction>
  private let cardResultStore: Store<WithSharedState<CardResultState>, CardResultAction>

  init(store: Store<WithSharedState<DiaryState>, DiaryAction>) {
    self.store = store
    self.cardResultStore = self.store.scope(
      state: \.cardResult,
      action: DiaryAction.cardResult
    )
  }

  var body: some View {
    WithViewStore(store.scope(state: \.local.userDiary)) { userDiaryViewStore in
      WithViewStore(store.scope(state: \.local.categoryImages)) { categoryImagesViewStore in
        WithViewStore(store.scope(state: \.local.categoryKeywords)) { categoryKeywordsViewStore in
          CardResultView(
            store: cardResultStore,
            recordDate: userDiaryViewStore.state.date,
            imageURLs: categoryImagesViewStore.state,
            title: userDiaryViewStore.state.title,
            keywords: categoryKeywordsViewStore.state,
            description: userDiaryViewStore.state.description,
            cardResult: .diary,
            backButtonAction: { ViewStore(store).send(.backButtonTapped) }
          )
        }
      }
    }
    .alertDoubleButton(
      store: store.scope(
        state: \.local.requestDeleteDiaryAlertModal,
        action: DiaryAction.requestDeleteDiaryAlertModal
      )
    )
    .alertDoubleButton(
      store: store.scope(
        state: \.local.moveDreamAlertModal,
        action: DiaryAction.moveDreamAlertModal
      )
    )
  }
}
