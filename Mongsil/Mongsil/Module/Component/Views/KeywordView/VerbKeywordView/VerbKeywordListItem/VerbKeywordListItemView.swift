//
//  VerbKeywordListItemView.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/17.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import NukeUI

struct VerbKeywordListItem: View {
  private let store: Store<VerbKeywordListItemState, VerbKeywordListItemAction>

  init(store: Store<VerbKeywordListItemState, VerbKeywordListItemAction>) {
    self.store = store
  }

  var body: some View {
    VStack(spacing: 0) {
      WithViewStore(store.scope(state: \.verb)) { verbViewStore in
        VerbKeywordItem(name: verbViewStore.state.name, categoryCount: verbViewStore.state.categories.count)
      }
      VerbCategoryListView(store: store)
      Rectangle().frame(height: 1).foregroundColor(.gray9)
    }
  }
}

private struct VerbCategoryListView: View {
  private let store: Store<VerbKeywordListItemState, VerbKeywordListItemAction>

  init(store: Store<VerbKeywordListItemState, VerbKeywordListItemAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.type)) { typeViewStore in
      DynamicForEachStore(
        store.scope(
          state: \.categoryListItemStates,
          action: VerbKeywordListItemAction.categoryListItem
        ),
        verticalSpacing: typeViewStore.state == .badge ? 12 : 8,
        horizontalSpacing: 8,
        content: CategoryListItemView.init(store:)
      )
      .padding(.vertical, 16)
      .padding(.horizontal, 20)
    }
  }
}
