//
//  SelectFilterSheetCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/23.
//

import Combine
import ComposableArchitecture
import IdentifiedCollections
import Foundation

struct SelectFilterSheetState: Equatable {
  var isAppliedCategories: Bool {
    self.appliedCategories.isNotEmpty
  }
  var appliedCategories: [Category] = []
  var selectedCategories: [Category] = []

  var searchResultCount: String = ""
  var searchKeyword: String = ""
  var isFilterSheetPresented: Bool = false
  var isConfirmFilterButtonAbled = false

  // Child State
  public var keyword: KeywordState = .init()
}

enum SelectFilterSheetAction: ToastPresentableAction {
  case onAppear

  case getCategories

  case setVerbKeywordListItemStates(IdentifiedArrayOf<VerbKeywordListItemState>)
  case setNounKeywordListItemStates(IdentifiedArrayOf<NounKeywordListItemState>)
  case setSelectedCategoryItemState([Category])

  case getSearchResultCount
  case getSearchResultCountResult(Result<Int, Error>)
  case setSearchResultCount(Int?)
  case setConfirmFilterButtonAbled(Bool)

  case setFilterSheetPresented(Bool)
  case setSearchKeyword(String)

  case confirmFilterButtonTapped
  case resetFilterButtonTapped
  case removeCategoryButtonTapped(Category)

  case removeSelectedCategory(Category)
  case removeAppliedCategory(Category)

  // Child Action
  case keyword(KeywordAction)

  case presentToast(String)
}

struct SelectFilterSheetEnvironment {
  let dreamService: DreamService
}

let selectFilterSheetReducer = Reducer.combine([
  keywordReducer.pullback(
    state: \.keyword,
    action: /SelectFilterSheetAction.keyword,
    environment: { _ in
      KeywordEnvironment()
    }
  ) as Reducer<SelectFilterSheetState, SelectFilterSheetAction, SelectFilterSheetEnvironment>,
  Reducer<SelectFilterSheetState, SelectFilterSheetAction, SelectFilterSheetEnvironment> {
    state, action, env in
    switch action {
    case .onAppear:
      return Effect.merge([
        Effect(value: .getCategories),
        Effect(value: .getSearchResultCount)
      ])

    case .getCategories:
      let selectedCategories = state.selectedCategories
      return env.dreamService.getDreamFilter()
        .catchToEffect()
        .flatMapLatest { result -> Effect<SelectFilterSheetAction, Never> in
          switch result {
          case let .success(response):

            let verbKeywordListItemStates = IdentifiedArrayOf(uniqueElements: response.verb.map { verb -> VerbKeywordListItemState in
              var verbKeywordListItemStates = VerbKeywordListItemState(verb: verb, type: .badge)

              let categoryListItemStates = verbKeywordListItemStates.categoryListItemStates.map { categoryListItemState -> CategoryListItemState in
                let isSelected = selectedCategories.contains(where: { categoryListItemState.category.id == $0.id })

                return CategoryListItemState(category: categoryListItemState.category, type: .badge, isSelected: isSelected)
              }

              verbKeywordListItemStates.categoryListItemStates = IdentifiedArrayOf(uniqueElements: categoryListItemStates)

              return verbKeywordListItemStates
            })

            let nounKeywordListItemStates = IdentifiedArrayOf(uniqueElements: response.noun.map { noun -> NounKeywordListItemState in
              var nounKeywordListItemStates = NounKeywordListItemState(noun: noun, type: .badge)

              let categoryListItemStates = nounKeywordListItemStates.categoryListItemStates.map { categoryListItemState -> CategoryListItemState in
                let isSelected = selectedCategories.contains(where: { categoryListItemState.category.id == $0.id })

                return CategoryListItemState(category: categoryListItemState.category, type: .badge, isSelected: isSelected)
              }

              nounKeywordListItemStates.categoryListItemStates = IdentifiedArrayOf(uniqueElements: categoryListItemStates)

              return nounKeywordListItemStates
            })

            return Effect.merge([
              Effect(value: .setVerbKeywordListItemStates(verbKeywordListItemStates)),
              Effect(value: .setNounKeywordListItemStates(nounKeywordListItemStates))
            ])
          case .failure:
            return Effect.merge([
              Effect(value: .setFilterSheetPresented(false)),
              Effect(value: .presentToast("키워드를 불러오지 못했어요. 잠시 후 다시 시도해주세요."))
            ])
          }
        }.eraseToEffect()

    case let .setVerbKeywordListItemStates(verbKeywordListItemStates):
      state.keyword.verbKeyword.verbKeywordListItemStates = verbKeywordListItemStates
      return .none

    case let .setNounKeywordListItemStates(nounKeywordListItemStates):
      state.keyword.nounKeyword.nounKeywordListItemStates = nounKeywordListItemStates
      return .none

    case let .setFilterSheetPresented(isFilterSheetPresented):
      state.isFilterSheetPresented = isFilterSheetPresented
      if isFilterSheetPresented {
        state.selectedCategories = state.appliedCategories
        state.searchResultCount = ""
      }
      return .none

    case let .setSearchKeyword(keyword):
      state.searchKeyword = keyword
      return .none

    case .confirmFilterButtonTapped:
      state.appliedCategories = state.selectedCategories
      return Effect(value: .setFilterSheetPresented(false))

    case .resetFilterButtonTapped:
      let categoryUnselectedEffect = state.selectedCategories
        .map { Effect<SelectFilterSheetAction, Never>(value: .removeSelectedCategory($0)) }

      return Effect.merge(
        categoryUnselectedEffect +
        [
          Effect(value: .setSelectedCategoryItemState([])),
          Effect(value: .getSearchResultCount)
        ]
      )

    case let .removeCategoryButtonTapped(category):
      return Effect.concatenate([
        Effect(value: .removeSelectedCategory(category)),
        Effect(value: .getSearchResultCount)
      ])

    case let .removeSelectedCategory(category):
      state.keyword.nounKeyword.nounKeywordListItemStates[id: category.parentsKeyword]?.categoryListItemStates[id: category.id]?.isSelected = false
      state.keyword.verbKeyword.verbKeywordListItemStates[id: category.parentsKeyword]?.categoryListItemStates[id: category.id]?.isSelected = false
      state.selectedCategories.removeAll(where: { $0.id == category.id })
      return .none

    case let .removeAppliedCategory(category):
      return Effect.merge([
        Effect(value: .removeSelectedCategory(category)),
        Effect(value: .confirmFilterButtonTapped)
      ])

    case let .keyword(.verbKeyword(.verbKeywordListItem(_, .categoryListItem(_, .tappedView(selectCategory))))):
      guard let isSelected = state.keyword.verbKeyword.verbKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected else {
        return .none
      }

      if isSelected {
        state.keyword.verbKeyword.verbKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = false
        return Effect(value: .setSelectedCategoryItemState(state.selectedCategories.filter { $0.id != selectCategory.id }))
      } else {
        state.keyword.verbKeyword.verbKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = true
        return Effect(value: .setSelectedCategoryItemState(state.selectedCategories + [selectCategory]))
      }

    case let .keyword(.nounKeyword(.nounKeywordListItem(_, .categoryListItem(_, .tappedView(selectCategory))))):
      guard let isSelected = state.keyword.nounKeyword.nounKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected else {
        return .none
      }

      if isSelected {
        state.keyword.nounKeyword.nounKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = false
        return Effect(value: .setSelectedCategoryItemState(state.selectedCategories.filter { $0.id != selectCategory.id }))
      } else {
        state.keyword.nounKeyword.nounKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = true
        return Effect(value: .setSelectedCategoryItemState(state.selectedCategories + [selectCategory]))
      }

    case let .setSelectedCategoryItemState(selectedCategories):
      state.selectedCategories = selectedCategories
      return Effect(value: .getSearchResultCount)

    case .getSearchResultCount:
      let categories = state.selectedCategories.map { $0.name }

      return env.dreamService.getSearchResultCount(keyword: state.searchKeyword, categories: categories)
        .catchToEffect()
        .map(SelectFilterSheetAction.getSearchResultCountResult)
        .eraseToEffect()

    case let .getSearchResultCountResult(result):
      switch result {
      case let .success(count):
        return Effect(value: .setSearchResultCount(count))
      case .failure:
        return Effect(value: .setSearchResultCount(nil))
      }

    case let .setSearchResultCount(count):
      if let count = count {
        state.searchResultCount = count > 0 ? "\(count)개 " : ""
        return Effect(value: .setConfirmFilterButtonAbled(count > 0))
      }
      state.searchResultCount = ""
      return Effect(value: .setConfirmFilterButtonAbled(true))

    case let .setConfirmFilterButtonAbled(isAbled):
      state.isConfirmFilterButtonAbled = isAbled
      return .none

    case .keyword:
      return .none

    case .presentToast:
      return .none
    }
  }
])
