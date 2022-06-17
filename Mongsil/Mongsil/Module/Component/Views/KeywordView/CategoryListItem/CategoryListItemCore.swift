//
//  CategoryListItemCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/16.
//

import Foundation
import ComposableArchitecture

struct CategoryListItemState: Equatable, Identifiable {
  var id: String { self.category.id }

  let category: Category
  let type: `Type`
  var isSelected: Bool

  init(category: Category, type: `Type`, isSelected: Bool = false) {
    self.category = category
    self.type = type
    self.isSelected = isSelected
  }
}

extension CategoryListItemState {
  public enum `Type` {
    case badge
    case image
  }
}

enum CategoryListItemAction {
  case tappedView(Category)
}

struct CategoryListItemEnvironment {

}

let categoryListItemReducer = Reducer.combine([
  Reducer<CategoryListItemState, CategoryListItemAction, CategoryListItemEnvironment> { _, action, _ in
    switch action {
    case .tappedView:
      return .none
    }
  }
])
