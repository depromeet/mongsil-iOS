//
//  VerbKeywordView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/10.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import NukeUI

struct VerbKeywordView: View {
  private let store: Store<VerbKeywordState, VerbKeywordAction>

  init(store: Store<VerbKeywordState, VerbKeywordAction>) {
    self.store = store
  }

  var body: some View {
    ScrollView(showsIndicators: false) {
      VerbKeywordListView(store: store)
    }
  }
}

private struct VerbKeywordListView: View {
  private let store: Store<VerbKeywordState, VerbKeywordAction>

  init(store: Store<VerbKeywordState, VerbKeywordAction>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      ForEachStore(
        store.scope(state: \.verbKeywordListItemStates, action: VerbKeywordAction.verbKeywordListItem),
        content: VerbKeywordListItem.init(store:)
      )
    }
  }
}
