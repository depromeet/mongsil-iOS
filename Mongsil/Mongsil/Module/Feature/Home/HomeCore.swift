//
//  HomeCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/04/02.
//

import Combine
import ComposableArchitecture

struct HomeState: Equatable {
  public var isSearchPushed: Bool = false
  public var hotKeyword: [String] = []
  
  // Child State
  public var search: SearchState?
  
  init(
    hotKeyword: [String] = [],
    search: SearchState? = nil
  ) {
    self.hotKeyword = hotKeyword
    self.search = search
  }
}

enum HomeAction {
  case onAppear
  case setSearchPushed(Bool)
  case hotKeywordTapped(String)
  
  // Child Action
  case search(SearchAction)
}

struct HomeEnvironment {
}

let homeReducer: Reducer<WithSharedState<HomeState>, HomeAction, HomeEnvironment> =
Reducer.combine([
  searchReducer
    .optional()
    .pullback(
      state: \.search,
      action: /HomeAction.search,
      environment: { _ in
        SearchEnvironment()
      }
    ) as Reducer<WithSharedState<HomeState>, HomeAction, HomeEnvironment>,
  Reducer<WithSharedState<HomeState>, HomeAction, HomeEnvironment> {
    state, action, _ in
    switch action {
    case .onAppear:
      // 추후 인기 해몽 키워드 API 호출 및 저장 필요
      state.local.hotKeyword = ["호랑이", "천사", "애플워치", "돼지", "돈", "회사", "바다", "부자"]
      return .none
      
    case let .setSearchPushed(pushed):
      state.local.isSearchPushed = pushed
      if pushed {
        state.local.search = .init()
      }
      return .none
      
    case let .hotKeywordTapped(text):
      return Effect(value: .setSearchPushed(true))
      
    case .search(.backButtonTapped):
      return Effect(value: .setSearchPushed(false))
      
    case .search:
      return .none
    }
  }
])
