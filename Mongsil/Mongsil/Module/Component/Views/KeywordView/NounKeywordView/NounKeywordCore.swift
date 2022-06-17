//
//  NounKeywordCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/10.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

struct NounKeywordState: Equatable {
  var nounKeywordListItemStates: IdentifiedArrayOf<NounKeywordListItemState> = []
}

enum NounKeywordAction: ToastPresentableAction {
  case presentToast(String)
  case nounKeywordListItem(NounKeywordListItemState.ID, NounKeywordListItemAction)
}

struct NounKeywordEnvironment {

}

let nounKeywordReducer = Reducer.combine(
  nounKeywordListItemReducer.forEach(
    state: \.nounKeywordListItemStates,
    action: /NounKeywordAction.nounKeywordListItem,
    environment: { _ in NounKeywordListItemEnvironment() }
  ),
  Reducer<NounKeywordState, NounKeywordAction, NounKeywordEnvironment> { _, action, _ in
    switch action {
    case .presentToast:
      return .none
    case .nounKeywordListItem:
      return .none
    }
  }
)
