//
//  SearchCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/09.
//

import Combine
import ComposableArchitecture
import IdentifiedCollections

struct SearchState: Equatable {
  public var hotKeywords: [String] = []

  var searchKeyword: String = ""

  var isSearchResultViewPushed: Bool = false

  // Child State
  public var keyword: KeywordState = .init()
  public var searchResult: SearchResultState?
}

extension SearchState {
  public enum Tab: Int, Comparable, Hashable, Identifiable {
    public var id: Int { rawValue }

    case noun
    case verb

    public static func < (lhs: Self, rhs: Self) -> Bool {
      return lhs.rawValue < rhs.rawValue
    }
  }
}

enum SearchAction: ToastPresentableAction {
  case onAppear

  case setHotKeywords([String])
  case setVerbKeywordListItemStates([Verb])
  case setNounKeywordListItemStates([Noun])

  case backButtonTapped
  case removeButtonTapped
  case searchButtonTapped
  case hotKeywordTapped(String)

  case search(String)

  case searchTextFieldChanged(String)

  case setSearchResultViewPushed(Bool)

  // Child Action
  case keyword(KeywordAction)
  case searchResult(SearchResultAction)

  case presentToast(String)
}

struct SearchEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  let dreamService: DreamService
  let diaryService: DiaryService
  let userDreamListService: UserDreamListService
}

let searchReducer = Reducer.combine([
  keywordReducer.pullback(
    state: \.local.keyword,
    action: /SearchAction.keyword,
    environment: { _ in
      KeywordEnvironment()
    }
  ) as Reducer<WithSharedState<SearchState>, SearchAction, SearchEnvironment>,
  searchResultReducer.optional().pullback(
    state: \.searchResult,
    action: /SearchAction.searchResult,
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
  ) as Reducer<WithSharedState<SearchState>, SearchAction, SearchEnvironment>,
  Reducer<WithSharedState<SearchState>, SearchAction, SearchEnvironment> {
    state, action, env in
    switch action {
    case .onAppear:

      let isEmptyKeyword = (state.local.keyword.nounKeyword.nounKeywordListItemStates.isEmpty &&
      state.local.keyword.verbKeyword.verbKeywordListItemStates.isEmpty) ||
      state.local.hotKeywords.isEmpty

      if isEmptyKeyword {
        return Effect.merge([
          env.dreamService.getDreamFilter()
            .catchToEffect()
            .flatMapLatest { result -> Effect<SearchAction, Never> in
              switch result {
              case let .success(response):
                return Effect.merge([
                  Effect(value: .setVerbKeywordListItemStates(response.verb)),
                  Effect(value: .setNounKeywordListItemStates(response.noun))
                ])
              case .failure:
                return Effect.merge([
                  Effect(value: .backButtonTapped),
                  Effect(value: .presentToast("키워드를 불러오지 못했습니다. 잠시 후 다시 시도해주세요."))
                ])
              }
            }.eraseToEffect(),
          env.dreamService.getHotKeywords()
            .catchToEffect()
            .flatMapLatest({ result -> Effect<SearchAction, Never> in
              switch result {
              case let .success(hotKeyword):
                return Effect(value: .setHotKeywords(hotKeyword.categories))
              case .failure:
                return Effect(value: .setHotKeywords(["호랑이", "천사", "애플워치", "돼지", "돈", "회사", "바다", "부자"]))
              }
            })
            .eraseToEffect()
        ])
      } else {
        return .none
      }

    case let .setHotKeywords(hotKeywords):
      state.local.hotKeywords = hotKeywords
      return .none

    case let .setVerbKeywordListItemStates(verbList):
      let verbKeywordListItemStates = IdentifiedArrayOf(
        uniqueElements: verbList.map { VerbKeywordListItemState(verb: $0, type: .badge) }
      )

      state.local.keyword.verbKeyword.verbKeywordListItemStates = verbKeywordListItemStates
      return .none

    case let .setNounKeywordListItemStates(nounList):
      let nounKeywordListItemStates = IdentifiedArrayOf(
        uniqueElements: nounList.map { NounKeywordListItemState(noun: $0, type: .badge) }
      )

      state.local.keyword.nounKeyword.nounKeywordListItemStates = nounKeywordListItemStates
      return .none

    case .backButtonTapped:
      return .none

    case .removeButtonTapped:
      return Effect(value: .searchTextFieldChanged(""))

    case .searchButtonTapped:
      if state.local.searchKeyword.isEmpty {
        return Effect(value: .presentToast("키워드를 입력해 주세요"))
      }
      return Effect(value: .search(state.local.searchKeyword))

    case let .hotKeywordTapped(HotKeyword):
      return Effect(value: .search(HotKeyword))

    case let .search(keyword):
      return Effect.concatenate([
        Effect(value: .setSearchResultViewPushed(true)),
        Effect(value: .searchTextFieldChanged("")),
        Effect(value: .searchResult(.search(keyword)))
      ])

    case let .searchTextFieldChanged(searchKeyword):
      state.local.searchKeyword = searchKeyword
      return .none

    case let .setSearchResultViewPushed(isSearchResultViewPushed):
      state.local.isSearchResultViewPushed = isSearchResultViewPushed
      if isSearchResultViewPushed {
        state.local.searchResult = .init()
      }
      return .none

    case let .keyword(.nounKeyword(.nounKeywordListItem(_, .categoryListItem(_, .tappedView(category))))):
      return Effect(value: .search(category.name))

    case let .keyword(.verbKeyword(.verbKeywordListItem(_, .categoryListItem(_, .tappedView(category))))):
      return Effect(value: .search(category.name))

    case .keyword:
      return .none

    case .searchResult(.backButtonTapped):
      return Effect(value: .setSearchResultViewPushed(false))

    case .searchResult:
      return .none

    case .presentToast:
      return .none
    }
  }
])
