//
//  VerbKeywordCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/10.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

struct VerbKeywordState: Equatable {
  var verbKeywordListItemStates: IdentifiedArrayOf<VerbKeywordListItemState> = []
}

enum VerbKeywordAction: ToastPresentableAction {
  case presentToast(String)
  case verbKeywordListItem(VerbKeywordListItemState.ID, VerbKeywordListItemAction)
}

struct VerbKeywordEnvironment {

}

let verbKeywordReducer = Reducer.combine([
  verbKeywordListItemReducer.forEach(
    state: \.verbKeywordListItemStates,
    action: /VerbKeywordAction.verbKeywordListItem,
    environment: { _ in VerbKeywordListItemEnvironment() }
  ),
  Reducer<VerbKeywordState, VerbKeywordAction, VerbKeywordEnvironment> { _, action, _ in
    switch action {
      case .presentToast:
        return .none
      case .verbKeywordListItem:
        return .none
    }
  }
])
