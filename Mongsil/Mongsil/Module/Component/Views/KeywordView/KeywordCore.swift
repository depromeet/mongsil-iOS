//
//  KeywordCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import Foundation
import ComposableArchitecture
import IdentifiedCollections

struct KeywordState: Equatable {
  var selectedTab: Tab = .noun

  // Child State
  public var verbKeyword: VerbKeywordState = .init()
  public var nounKeyword: NounKeywordState = .init()
}

extension KeywordState {
  public enum Tab: Int, Comparable, Hashable, Identifiable {
    public var id: Int { rawValue }

    case noun
    case verb

    public static func < (lhs: Self, rhs: Self) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
}

enum KeywordAction: ToastPresentableAction {
  case tabTapped(KeywordState.Tab)

  // Child Action
  case verbKeyword(VerbKeywordAction)
  case nounKeyword(NounKeywordAction)

  case presentToast(String)
}

struct KeywordEnvironment {

}

let keywordReducer = Reducer.combine([
  verbKeywordReducer.pullback(
    state: \.verbKeyword,
    action: /KeywordAction.verbKeyword,
    environment: { _ in
      VerbKeywordEnvironment()
    }
  ) as Reducer<KeywordState, KeywordAction, KeywordEnvironment>,
  nounKeywordReducer.pullback(
    state: \.nounKeyword,
    action: /KeywordAction.nounKeyword,
    environment: { _ in
      NounKeywordEnvironment()
    }
  ) as Reducer<KeywordState, KeywordAction, KeywordEnvironment>,

  Reducer<KeywordState, KeywordAction, KeywordEnvironment> { state, action, _ in
    switch action {
    case let .tabTapped(selectedTab):
      state.selectedTab = selectedTab
      return .none
    case .verbKeyword:
      return .none
    case .nounKeyword:
      return .none
    case .presentToast:
      return .none
    }
  }
]
)
