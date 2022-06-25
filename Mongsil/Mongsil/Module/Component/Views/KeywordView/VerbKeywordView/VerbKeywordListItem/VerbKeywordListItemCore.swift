//
//  VerbKeywordListItemCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/17.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

struct VerbKeywordListItemState: Equatable, Identifiable {
  var id: String { self.verb.name }

  var verb: Verb
  var categoryListItemStates: IdentifiedArrayOf<CategoryListItemState>
  var type: CategoryListItemState.`Type`

  init(verb: Verb, type: CategoryListItemState.`Type`) {
    self.verb = verb
    self.categoryListItemStates = IdentifiedArrayOf(uniqueElements: verb.categories.map { CategoryListItemState(category: $0, type: type) })
    self.type = type
  }
}

enum VerbKeywordListItemAction {
  case categoryListItem(CategoryListItemState.ID, CategoryListItemAction)
}

struct VerbKeywordListItemEnvironment {

}

let verbKeywordListItemReducer = Reducer.combine([
  categoryListItemReducer.forEach(
    state: \.categoryListItemStates,
    action: /VerbKeywordListItemAction.categoryListItem,
    environment: { _ in CategoryListItemEnvironment() }
  ),
  Reducer<VerbKeywordListItemState, VerbKeywordListItemAction, VerbKeywordListItemEnvironment> { _, action, _ in
    switch action {
    case .categoryListItem:
      return .none
    }
  }
])
