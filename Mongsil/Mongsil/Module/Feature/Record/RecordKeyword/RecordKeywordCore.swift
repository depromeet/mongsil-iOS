//
//  RecordKeywordCore.swift
//  Mongsil
//
//  Created by Chanwoo Cho on 2022/05/15.
//

import Combine
import ComposableArchitecture
import IdentifiedCollections

struct RecordKeywordState: Equatable {
  public var titleText: String
  public var mainText: String

  public var isStroeButtonAbled: Bool = false
  public var isNotPreference: Bool = false

  public var currentDate: Date
  public var selectedDateToStr: String {
    return  convertDateToString(currentDate)
  }
  public var selectedCategories: [Category]
  public var editTarget: Diary?
  public var toastText: String?

  // Child State
  public var keyword: KeywordState = .init()

  init(titleText: String, mainText: String, currentDate: Date, editTarget: Diary? = nil) {
    self.titleText = titleText
    self.mainText = mainText
    self.currentDate = currentDate

    self.selectedCategories = editTarget?.categories ?? []
    if let _ = editTarget, selectedCategories.isEmpty {
      self.isNotPreference = true
    }
    self.editTarget = editTarget
  }
}

enum RecordKeywordAction: ToastPresentableAction {
  case onAppear
  case dreamFilterResult(Result<DreamFilterResponseDto, Error>)

  case backButtonTapped
  case setNextButtonAbled(Bool)
  case setIsNotPreference(Bool)
  case setSelectedDate(Date)
  case setSelectedCategoryItemState([Category])
  case removeCategoriesButton(Category)
  case saveBtnTapped
  case successSave(String)
  case moveToDiaryView(Diary?)

  case setVerbKeywordListItemStates(IdentifiedArrayOf<VerbKeywordListItemState>)
  case setNounKeywordListItemStates(IdentifiedArrayOf<NounKeywordListItemState>)

  // Child Action
  case keyword(KeywordAction)

  case hideToast
  case presentToast(String)
}

struct RecordKeywordEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  let dreamService: DreamService
  let diaryService: DiaryService
}

let recordKeywordReducer = Reducer.combine([
  keywordReducer.pullback(
    state: \.local.keyword,
    action: /RecordKeywordAction.keyword,
    environment: { _ in
      KeywordEnvironment()
    }
  ) as Reducer<WithSharedState<RecordKeywordState>, RecordKeywordAction, RecordKeywordEnvironment>,
  Reducer<WithSharedState<RecordKeywordState>, RecordKeywordAction, RecordKeywordEnvironment> {
    state, action, env in

    struct RecordKeywordToastCancelId: Hashable {}

    switch action {
    case .onAppear:
      return env.dreamService.getDreamFilter()
        .catchToEffect()
        .map(RecordKeywordAction.dreamFilterResult)
        .eraseToEffect()

    case let .dreamFilterResult(result):
      let selectedCategories = state.local.selectedCategories

      switch result {
      case let .success(response):
        let verbKeywordListItemStates = IdentifiedArrayOf(uniqueElements: response.verb.map { verb -> VerbKeywordListItemState in
          var verbKeywordListItemStates = VerbKeywordListItemState(verb: verb, type: .image)

          let categoryListItemStates = verbKeywordListItemStates.categoryListItemStates.map { categoryListItemState -> CategoryListItemState in
            let isSelected = selectedCategories.contains(where: { categoryListItemState.category.id == $0.id })

            return CategoryListItemState(category: categoryListItemState.category, type: .image, isSelected: isSelected)
          }

          verbKeywordListItemStates.categoryListItemStates = IdentifiedArrayOf(uniqueElements: categoryListItemStates)

          return verbKeywordListItemStates
        })

        let nounKeywordListItemStates = IdentifiedArrayOf(uniqueElements: response.noun.map { noun -> NounKeywordListItemState in
          var nounKeywordListItemStates = NounKeywordListItemState(noun: noun, type: .image)

          let categoryListItemStates = nounKeywordListItemStates.categoryListItemStates.map { categoryListItemState -> CategoryListItemState in
            let isSelected = selectedCategories.contains(where: { categoryListItemState.category.id == $0.id })

            return CategoryListItemState(category: categoryListItemState.category, type: .image, isSelected: isSelected)
          }

          nounKeywordListItemStates.categoryListItemStates = IdentifiedArrayOf(uniqueElements: categoryListItemStates)

          return nounKeywordListItemStates
        })

        return Effect.merge([
          Effect(value: .setNextButtonAbled(state.local.selectedCategories.isNotEmpty || state.local.isNotPreference)),
          Effect(value: .setVerbKeywordListItemStates(verbKeywordListItemStates)),
          Effect(value: .setNounKeywordListItemStates(nounKeywordListItemStates))
        ])
      case let .failure(error):
        return Effect.merge([
          Effect(value: .backButtonTapped),
          Effect(value: .presentToast("키워드를 불러오지 못했어요. 잠시 후 다시 시도해주세요."))
        ])
      }

    case .backButtonTapped:
      return .none

    case let .setNextButtonAbled(isStroeButtonAbled):
      state.local.isStroeButtonAbled = isStroeButtonAbled
      return .none

    case let .setIsNotPreference(isNotPreference):
      state.local.isNotPreference = isNotPreference

      if isNotPreference {
        let categoryUnselectedEffect = state.local.selectedCategories
          .map { Effect<RecordKeywordAction, Never>(value: .removeCategoriesButton($0)) }

        return Effect.merge(categoryUnselectedEffect +
          [
            Effect(value: .setSelectedCategoryItemState([])),
            Effect(value: .presentToast("열심히 키워드 추가 중! 조금만 기다려주세요.")),
            Effect(value: .setNextButtonAbled(true))
          ]
        )
      } else {
        return Effect(value: .setNextButtonAbled(false))
      }

    case let .setSelectedDate(date):
      state.local.currentDate = date
      return .none

    case let .setSelectedCategoryItemState(selectedCategories):
      state.local.selectedCategories = selectedCategories

      let isNextButtonAbled = state.local.selectedCategories.isNotEmpty || state.local.isNotPreference

      return Effect(value: .setNextButtonAbled(isNextButtonAbled))

    case let .keyword(.verbKeyword(.verbKeywordListItem(_, .categoryListItem(_, .tappedView(selectCategory))))):
      guard let isSelected = state.local.keyword.verbKeyword.verbKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected else {
        return .none
      }
      let isAbleSelected = state.local.selectedCategories.count < 2

      if isSelected {
        state.local.keyword.verbKeyword.verbKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = false
        return Effect(value: .setSelectedCategoryItemState(state.local.selectedCategories.filter { $0.id != selectCategory.id }))
      } else {
        if isAbleSelected {
          state.local.keyword.verbKeyword.verbKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = true
          return Effect(value: .setSelectedCategoryItemState(state.local.selectedCategories + [selectCategory]))
        } else {
          return Effect(value: .presentToast("키워드는 두 개 까지 선택할 수 있어요"))
        }
      }

    case let .keyword(.nounKeyword(.nounKeywordListItem(_, .categoryListItem(_, .tappedView(selectCategory))))):
      guard let isSelected = state.local.keyword.nounKeyword.nounKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected else {
        return .none
      }
      let isAbleSelected = state.local.selectedCategories.count < 2

      if isSelected {
        state.local.keyword.nounKeyword.nounKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = false
        return Effect(value: .setSelectedCategoryItemState(state.local.selectedCategories.filter { $0.id != selectCategory.id }))
      } else {
        if isAbleSelected {
          state.local.keyword.nounKeyword.nounKeywordListItemStates[id: selectCategory.parentsKeyword]?.categoryListItemStates[id: selectCategory.id]?.isSelected = true
          return Effect(value: .setSelectedCategoryItemState(state.local.selectedCategories + [selectCategory]))
        } else {
          return Effect(value: .presentToast("키워드는 두 개 까지 선택할 수 있어요"))
        }
      }

    case let .removeCategoriesButton(category):
      state.local.keyword.nounKeyword.nounKeywordListItemStates[id: category.parentsKeyword]?.categoryListItemStates[id: category.id]?.isSelected = false
      state.local.keyword.verbKeyword.verbKeywordListItemStates[id: category.parentsKeyword]?.categoryListItemStates[id: category.id]?.isSelected = false
      state.local.selectedCategories.removeAll(where: { $0.id == category.id })
      state.local.isStroeButtonAbled = state.local.selectedCategories.isNotEmpty
      return .none

    case .saveBtnTapped:
      guard let userID = state.shared.userID else {
        return .none
      }

      if let editTarget = state.local.editTarget {
        return env.diaryService.editDiary(
          cardID: editTarget.id,
          title: state.local.titleText,
          description: state.local.mainText,
          categories: state.local.selectedCategories.map { $0.id }
        ).catchToEffect()
          .flatMapLatest({ result -> Effect<RecordKeywordAction, Never> in
            switch result {
            case .success:
              return Effect(value: .successSave(editTarget.id))
            case .failure:
              return Effect(value: .presentToast("기록 수정에 실패했어요. 다시 시도해 주세요."))
            }
          })
          .eraseToEffect()
      }

      return env.diaryService.saveDiary(
        userID: userID,
        title: state.local.titleText,
        description: state.local.mainText,
        registerDate: state.local.currentDate,
        categories: state.local.selectedCategories.map { $0.id }
      ).catchToEffect()
        .flatMapLatest({ result -> Effect<RecordKeywordAction, Never> in
          switch result {
          case let .success(response):
            return Effect(value: .successSave(response.diaryID))
          case .failure:
            return Effect(value: .presentToast("기록하기에 실패했어요. 다시 시도해 주세요."))
          }
        })
        .eraseToEffect()

    case let .successSave(diaryID):
      return env.diaryService.getDiary(diaryID: diaryID)
        .catchToEffect()
        .flatMapLatest { result -> Effect<RecordKeywordAction, Never> in
          switch result {
          case let .success(response):
            return Effect(value: .moveToDiaryView(response))
          case .failure(let error):
            return Effect(value: .moveToDiaryView(nil))
          }
        }.eraseToEffect()

    case .moveToDiaryView:
      return .none

    case let .setVerbKeywordListItemStates(verbKeywordListItemStates):
      state.local.keyword.verbKeyword.verbKeywordListItemStates = verbKeywordListItemStates
      return .none

    case let .setNounKeywordListItemStates(nounKeywordListItemStates):
      state.local.keyword.nounKeyword.nounKeywordListItemStates = nounKeywordListItemStates
      return .none

    case .keyword:
      return .none

    case .hideToast:
      state.local.toastText = nil
      return .none

    case let .presentToast(toastText):
      state.local.toastText = toastText
      return Effect<RecordKeywordAction, Never>.concatenate([
        .cancel(id: RecordKeywordToastCancelId()),
        Effect<RecordKeywordAction, Never>(value: .hideToast)
          .delay(for: 3, scheduler: env.mainQueue)
          .eraseToEffect()
          .cancellable(id: RecordKeywordToastCancelId(), cancelInFlight: true)
      ])

    }
  }
])
