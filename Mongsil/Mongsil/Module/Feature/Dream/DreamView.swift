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

  init(store: Store<WithSharedState<DreamState>, DreamAction>) {
    self.store = store
  }

  var body: some View {
    VStack {
      MSNavigationBar(
        backButtonImage: R.CustomImage.backIcon.image,
        backButtonAction: { ViewStore(store).send(.backButtonTapped) }
      )
      WithViewStore(store.scope(state: \.local.dream)) { dreamViewStore in
        Text("\(dreamViewStore.state.title)")
      }

      Spacer()
    }
    .navigationBarHidden(true)
  }
}
