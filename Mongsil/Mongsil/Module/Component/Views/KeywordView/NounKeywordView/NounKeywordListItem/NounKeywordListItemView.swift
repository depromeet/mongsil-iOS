//
//  File.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/16.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import NukeUI

struct NounKeywordListItem: View {
  private let store: Store<NounKeywordListItemState, NounKeywordListItemAction>

  init(store: Store<NounKeywordListItemState, NounKeywordListItemAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.isActive)) { isActiveViewStore in
      VStack(spacing: 0) {
        WithViewStore(store.scope(state: \.noun)) { nounViewStore in
          NounKeywordItem(
            name: nounViewStore.state.name,
            image: nounViewStore.state.image,
            categoryCount: nounViewStore.state.categories.count,
            isActive: isActiveViewStore.state,
            tappedAction: {
              hideKeyboard()
              ViewStore(store).send(.tappedView)
            }
          )
        }
        Rectangle().frame(height: 1).foregroundColor(.gray9)
        if isActiveViewStore.state {
          HStack(alignment: .center, spacing: 0) {
            Spacer()
            NounCategoryListView(store: store)
            Spacer()
          }
          Rectangle().frame(height: 1).foregroundColor(.gray9)
        }
      }
    }
  }
}

private struct NounCategoryListView: View {
  private let store: Store<NounKeywordListItemState, NounKeywordListItemAction>

  init(store: Store<NounKeywordListItemState, NounKeywordListItemAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: \.type)) { typeViewStore in
      DynamicForEachStore(
        store.scope(
          state: \.categoryListItemStates,
          action: NounKeywordListItemAction.categoryListItem
        ),
        verticalSpacing: typeViewStore.state == .badge ? 12 : 8,
        horizontalSpacing: 8,
        content: CategoryListItemView.init(store:)
      ).padding(.vertical, 16)
        .onTapGesture {
          hideKeyboard()
        }
    }
  }
}
