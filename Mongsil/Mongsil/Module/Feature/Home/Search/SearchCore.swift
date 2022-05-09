//
//  SearchCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/09.
//

import Combine
import ComposableArchitecture

struct SearchState: Equatable {
}

enum SearchAction {
  case backButtonTapped
}

struct SearchEnvironment {
}

let searchReducer = Reducer<WithSharedState<SearchState>, SearchAction, SearchEnvironment> {
  _, action, _ in
  switch action {
  case .backButtonTapped:
    return .none
  }
}
