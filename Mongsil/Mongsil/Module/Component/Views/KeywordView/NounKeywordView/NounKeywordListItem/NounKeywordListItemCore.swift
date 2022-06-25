//
//  NounKeywordListItemCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/16.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

struct NounKeywordListItemState: Equatable, Identifiable {
  var id: String { self.noun.name }

  var noun: Noun
  var isActive: Bool
  var categoryListItemStates: IdentifiedArrayOf<CategoryListItemState>
  var type: CategoryListItemState.`Type`

  init(noun: Noun, type: CategoryListItemState.`Type`, isActive: Bool = false) {
    self.noun = noun
    self.isActive = isActive
    self.categoryListItemStates = IdentifiedArrayOf(uniqueElements: noun.categories.map { CategoryListItemState(category: $0, type: type) })
    self.type = type
  }
}

enum NounKeywordListItemAction {
  case tappedView
  case categoryListItem(CategoryListItemState.ID, CategoryListItemAction)
}

struct NounKeywordListItemEnvironment {

}

let nounKeywordListItemReducer = Reducer.combine([
  categoryListItemReducer.forEach(
    state: \.categoryListItemStates,
    action: /NounKeywordListItemAction.categoryListItem,
    environment: { _ in CategoryListItemEnvironment() }
  ),
  Reducer<NounKeywordListItemState, NounKeywordListItemAction, NounKeywordListItemEnvironment> { state, action, _ in
    switch action {
    case .tappedView:
      state.isActive.toggle()
      return .none
    case .categoryListItem:
      return .none
    }
  }
])
