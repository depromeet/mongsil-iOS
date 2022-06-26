//
//  SearchResultCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/21.
//

import Combine
import ComposableArchitecture
import IdentifiedCollections
import Foundation

struct SearchResultState: Equatable {
  var searchedKeyword: String = ""
  var searchKeyword: String = ""

  var isSearched: Bool {
    self.searchKeyword == self.searchedKeyword
  }
  var searchResult: [SearchResult] = []
  var searchResultCount: Int {
    self.searchResult.count
  }
  var isExitSearchResult: Bool {
    self.searchResult.isNotEmpty
  }
  var isSearchResultDetailPushed: Bool = false

  // Child State
  public var searchResultDetail: SearchResultDetailState?
  public var keyword: KeywordState = .init()
  public var selectFilterSheet: SelectFilterSheetState = .init()
}

enum SearchResultAction: ToastPresentableAction {
  case fetchKeyword

  case setVerbKeywordListItemStates([Verb])
  case setNounKeywordListItemStates([Noun])

  case searchTextFieldChanged(String)

  case backButtonTapped
  case removeButtonTapped
  case searchButtonTapped
  case filterButtonTapped
  case resetFilterButtonTapped
  case removeCategoryButtonTapped(Category)

  case search(_ keyword: String, _ categories: [String] = [])

  case setSearchedKeyword(String)
  case setSearchResult([SearchResult])

  case setSearchResultDetailPushed(Bool, SearchResult? = nil)

  // Child Action
  case searchResultDetail(SearchResultDetailAction)
  case keyword(KeywordAction)
  case selectFilterSheet(SelectFilterSheetAction)

  case presentToast(String)
}

struct SearchResultEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var kakaoLoginService: KakaoLoginService
  var userService: UserService
  var signUpService: SignUpService
  let dreamService: DreamService
  let diaryService: DiaryService
  let userDreamListService: UserDreamListService
}

let searchResultReducer = Reducer.combine([
  searchResultDetailReducer.optional().pullback(
    state: \.searchResultDetail,
    action: /SearchResultAction.searchResultDetail,
    environment: {
      SearchResultDetailEnvironment(
        mainQueue: $0.mainQueue,
        kakaoLoginService: $0.kakaoLoginService,
        userService: $0.userService,
        signUpService: $0.signUpService,
        diaryService: $0.diaryService,
        dreamService: $0.dreamService,
        userDreamListService: $0.userDreamListService
      )
    }
  ) as Reducer<WithSharedState<SearchResultState>, SearchResultAction, SearchResultEnvironment>,
  keywordReducer.pullback(
    state: \.local.keyword,
    action: /SearchResultAction.keyword,
    environment: { _ in
      KeywordEnvironment()
    }
  ) as Reducer<WithSharedState<SearchResultState>, SearchResultAction, SearchResultEnvironment>,
  selectFilterSheetReducer.pullback(
    state: \.local.selectFilterSheet,
    action: /SearchResultAction.selectFilterSheet,
    environment: {
      SelectFilterSheetEnvironment(dreamService: $0.dreamService)
    }
  ) as Reducer<WithSharedState<SearchResultState>, SearchResultAction, SearchResultEnvironment>,
  Reducer<WithSharedState<SearchResultState>, SearchResultAction, SearchResultEnvironment> {
    state, action, env in
    switch action {
    case .fetchKeyword:
      return env.dreamService.getDreamFilter()
        .catchToEffect()
        .flatMapLatest { result -> Effect<SearchResultAction, Never> in
          switch result {
          case let .success(response):
            return Effect.merge([
              Effect(value: .setVerbKeywordListItemStates(response.verb)),
              Effect(value: .setNounKeywordListItemStates(response.noun))
            ])
          case .failure:
            return Effect.merge([
              Effect(value: .backButtonTapped),
              Effect(value: .presentToast("키워드를 불러오지 못했어요. 잠시 후 다시 시도해주세요."))
            ])
          }
        }.eraseToEffect()

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

    case let .searchTextFieldChanged(searchKeyword):
      state.local.searchKeyword = searchKeyword
      return .none

    case .backButtonTapped:
      return .none

    case .removeButtonTapped:
      return Effect(value: .searchTextFieldChanged(""))

    case .searchButtonTapped:
      return Effect(value: .search(state.local.searchKeyword))

    case .filterButtonTapped:
      return Effect(value: .selectFilterSheet(.setFilterSheetPresented(true)))

    case .resetFilterButtonTapped:
      return .none

    case let .removeCategoryButtonTapped(category):
      return Effect(value: .selectFilterSheet(.removeAppliedCategory(category)))

    case let .search(searchKeyword, categories):
      state.local.searchKeyword = searchKeyword
      return env.dreamService.getSearchResult(keyword: state.local.searchKeyword, categories: categories)
        .catchToEffect()
        .flatMapLatest { result -> Effect<SearchResultAction, Never> in
          switch result {
          case let .success(searchResult):
            return Effect.merge([
              Effect(value: .setSearchResult(searchResult)),
              Effect(value: .setSearchedKeyword(searchKeyword))
            ])
          case .failure:
            return Effect(value: .presentToast("검색 결과를 불러올 수 없어요. 다시 시도해 주세요."))
          }
        }.eraseToEffect()

    case let .setSearchedKeyword(searchedKeyword):
      state.local.searchedKeyword = searchedKeyword
      return Effect(value: .selectFilterSheet(.setSearchKeyword(searchedKeyword)))

    case let .setSearchResult(searchResult):
      state.local.searchResult = searchResult
      return .none

    case let .setSearchResultDetailPushed(pushed, searchResult):
      state.local.isSearchResultDetailPushed = pushed
      guard let searchResult = searchResult else {
        return .none
      }
      if pushed {
        state.local.searchResultDetail = .init(searchResult: searchResult)
      }
      return .none

    case let .keyword(.nounKeyword(.nounKeywordListItem(_, .categoryListItem(_, .tappedView(category))))):
      return Effect(value: .search(category.name))

    case let .keyword(.verbKeyword(.verbKeywordListItem(_, .categoryListItem(_, .tappedView(category))))):
      return Effect(value: .search(category.name))

    case .searchResultDetail(.backButtonTapped):
      return Effect(value: .setSearchResultDetailPushed(false))

    case .selectFilterSheet(.confirmFilterButtonTapped):
      return Effect(value: .search(state.local.searchedKeyword, state.local.selectFilterSheet.appliedCategories.map { $0.name }))

    case .searchResultDetail:
      return .none

    case .keyword:
      return .none

    case .selectFilterSheet:
      return .none

    case .presentToast:
      return .none
    }
  }
])
