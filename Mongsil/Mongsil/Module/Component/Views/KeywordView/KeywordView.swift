//
//  KeywordView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct KeywordView: View {
  private let store: Store<KeywordState, KeywordAction>

  init(store: Store<KeywordState, KeywordAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.selectedTab)) { selectedTabViewStore in
      SegmentView<KeywordState.Tab>(
        title: [
          .noun: "명사",
          .verb: "동사/형용사"
        ],
        views: [
          .noun:
            NounKeywordView(store: store.scope(state: \.nounKeyword, action: KeywordAction.nounKeyword))
            .eraseToAnyView(),
          .verb:
            VerbKeywordView(store: store.scope(state: \.verbKeyword, action: KeywordAction.verbKeyword))
            .eraseToAnyView()
        ],
        selection: selectedTabViewStore.binding(
          send: KeywordAction.tabTapped
        )
      )
    }.padding(.top, 8)
  }
}
