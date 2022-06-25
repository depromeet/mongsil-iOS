//
//  NounKeywordView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/10.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import NukeUI

struct NounKeywordView: View {
  private let store: Store<NounKeywordState, NounKeywordAction>

  init(store: Store<NounKeywordState, NounKeywordAction>) {
    self.store = store
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      NounKeywordListView(store: store)
    }
  }
}

private struct NounKeywordListView: View {
  private let store: Store<NounKeywordState, NounKeywordAction>

  init(store: Store<NounKeywordState, NounKeywordAction>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      ForEachStore(
        store.scope(state: \.nounKeywordListItemStates, action: NounKeywordAction.nounKeywordListItem),
        content: NounKeywordListItem.init(store:)
      )
    }
  }
}
