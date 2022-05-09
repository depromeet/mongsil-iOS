//
//  SearchView.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/09.
//

import SwiftUI
import ComposableArchitecture

struct SearchView: View {
  private let store: Store<WithSharedState<SearchState>, SearchAction>

  init(store: Store<WithSharedState<SearchState>, SearchAction>) {
    self.store = store
  }

  var body: some View {
    MSNavigationBar(
      titleText: "검색",
      backButtonAction: { ViewStore(store).send(.backButtonTapped) }
    )
  }
}
