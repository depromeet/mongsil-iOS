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
  public var hotKeywords: [String] = []

  // Child State
  public var search: SearchState?

  init(
    hotKeywords: [String] = [],
    search: SearchState? = nil
  ) {
    self.hotKeywords = hotKeywords
    self.search = search
  }
}

enum HomeAction {
  case onAppear
  case setHotKeywords([String])
  case setSearchPushed(Bool)
  case hotKeywordTapped(String)

  // Child Action
  case search(SearchAction)
}

struct HomeEnvironment {
  var dreamService: DreamService

  init(
    dreamService: DreamService
  ) {
    self.dreamService = dreamService
  }
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
    state, action, env in
    switch action {
    case .onAppear:
      return env.dreamService.getHotKeywords()
        .catchToEffect()
        .flatMapLatest({ result -> Effect<HomeAction, Never> in
          switch result {
          case let .success(hotKeyword):
            return Effect(value: .setHotKeywords(hotKeyword.categories))
          case .failure:
            return Effect(value: .setHotKeywords(["호랑이", "천사", "애플워치", "돼지", "돈", "회사", "바다", "부자"]))
          }
        })
        .eraseToEffect()

    case let .setHotKeywords(hotKeywords):
      state.local.hotKeywords = hotKeywords
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
