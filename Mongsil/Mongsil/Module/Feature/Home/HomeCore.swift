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
  public var isSearchResultPushed: Bool = false
  public var hotKeywords: [String] = []

  // Child State
  public var search: SearchState?
  public var searchResult: SearchResultState?

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
  case setSearchResultPushed(Bool)
  case hotKeywordTapped(String)

  // Child Action
  case search(SearchAction)
  case searchResult(SearchResultAction)
}

struct HomeEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  let dreamService: DreamService
  let diaryService: DiaryService
  let userDreamListService: UserDreamListService
}

let homeReducer: Reducer<WithSharedState<HomeState>, HomeAction, HomeEnvironment> =
Reducer.combine([
  searchReducer
    .optional()
    .pullback(
      state: \.search,
      action: /HomeAction.search,
      environment: {
        SearchEnvironment(
          mainQueue: $0.mainQueue,
          kakaoLoginService: $0.kakaoLoginService,
          userService: $0.userService,
          signUpService: $0.signUpService,
          dreamService: $0.dreamService,
          diaryService: $0.diaryService,
          userDreamListService: $0.userDreamListService
        )
      }
    ) as Reducer<WithSharedState<HomeState>, HomeAction, HomeEnvironment>,
  searchResultReducer.optional().pullback(
    state: \.searchResult,
    action: /HomeAction.searchResult,
    environment: {
      SearchResultEnvironment(
        mainQueue: $0.mainQueue,
        kakaoLoginService: $0.kakaoLoginService,
        userService: $0.userService,
        signUpService: $0.signUpService,
        dreamService: $0.dreamService,
        diaryService: $0.diaryService,
        userDreamListService: $0.userDreamListService
      )
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

    case let .setSearchResultPushed(pushed):
      state.local.isSearchResultPushed = pushed
      if pushed {
        state.local.searchResult = .init()
      }
      return .none

    case let .hotKeywordTapped(text):
      return Effect.concatenate([
        Effect(value: .setSearchResultPushed(true)),
        Effect(value: .searchResult(.search(text)))
      ])

    case .search(.backButtonTapped):
      return Effect(value: .setSearchPushed(false))

    case .search:
      return .none

    case .searchResult(.backButtonTapped):
      return Effect(value: .setSearchResultPushed(false))

    case .searchResult:
      return .none
    }
  }
])
