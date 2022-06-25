//
//  SearchResultDetailCore.swift
//  Mongsil
//
//  Created by 이영은 on 2022/06/23.
//

import Combine
import ComposableArchitecture

struct SearchResultDetailState: Equatable {
  fileprivate var searchResult: SearchResult
  var searchResultDetail: Dream?

  public init(searchResult: SearchResult) {
    self.searchResult = searchResult
  }

  // Child State
  var cardResult: CardResultState = .init()
  var alertDoubleButtonAlert: AlertDoubleButtonState?
}

enum SearchResultDetailAction: ToastPresentableAction {
  case onAppear
  case setSearchResultDetail(Dream)
  case backButtonTapped

  case moveToStorage

  case saveDreamResult(Result<Unit, Error>)

  // Child Action
  case cardResult(CardResultAction)
  case alertDoubleButtonAlert(AlertDoubleButtonAction)

  case presentToast(String)
}

struct SearchResultDetailEnvironment {
  let mainQueue: AnySchedulerOf<DispatchQueue>
  var diaryService: DiaryService
  var dreamService: DreamService
  var userDreamListService: UserDreamListService
}

let searchResultDetailReducer: Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment> =
Reducer.combine([
  cardResultReducer
    .pullback(
      state: \.cardResult,
      action: /SearchResultDetailAction.cardResult,
      environment: {
        CardResultEnvironment(mainQueue: $0.mainQueue, diaryService: $0.diaryService, dreamService: $0.dreamService)
      }
    )
  as Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment>,
  alertDoubleButtonReducer
    .optional()
    .pullback(
      state: \.local.alertDoubleButtonAlert,
      action: /SearchResultDetailAction.alertDoubleButtonAlert,
      environment: { _ in
        AlertDoubleButtonEnvironment()
      }
    ) as Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment>,
  Reducer<WithSharedState<SearchResultDetailState>, SearchResultDetailAction, SearchResultDetailEnvironment> {
    state, action, env in
    switch action {
    case .onAppear:
      return env.dreamService.getSearchResultDetail(id: state.local.searchResult.id)
        .catchToEffect()
        .flatMapLatest({ result -> Effect<SearchResultDetailAction, Never> in
          switch result {
          case let .success(searchResultDetail):
            return Effect(value: .setSearchResultDetail(searchResultDetail))
          case .failure(let error):
            return Effect.merge([
              Effect(value: .backButtonTapped),
              Effect(value: .presentToast("해몽을 조회하지 못했어요. 잠시 후 다시 시도해 주세요."))
            ])
          }
        })
        .eraseToEffect()

    case let .setSearchResultDetail(searchResultDetail):
      state.local.searchResultDetail = searchResultDetail
      return .none

    case .backButtonTapped:
      return .none

    case .moveToStorage:
      return .none

    case .cardResult(.saveDream):
      guard let userID = state.shared.userID else { return .none }
      guard let dreamID = state.local.searchResultDetail?.id else { return .none }

      return env.userDreamListService.saveUserDream(userID: userID, dreamID: dreamID)
        .catchToEffect()
        .map(SearchResultDetailAction.saveDreamResult)
        .eraseToEffect()

    case let .saveDreamResult(result):
      switch result {
      case let .success(searchResultDetail):
        return setAlertModal(
          state: &state.local.alertDoubleButtonAlert,
          titleText: "해몽을 저장했어요!",
          bodyText: "저장된 해몽은 언제든지 보관함에서\n꺼내볼 수 잇어요.",
          secondaryButtonTitle: "보관함 가기",
          secondaryButtonHierachy: .secondary,
          primaryButtonTitle: "닫기",
          primaryButtonHierachy: .primary
        )
      case .failure:
        return Effect(value: .presentToast("‘해몽이 저장되지 않았어요. 다시 시도해주세요."))
      }

    case .alertDoubleButtonAlert(.secondaryButtonTapped):
      return Effect(value: .moveToStorage)

    case .alertDoubleButtonAlert(.primaryButtonTapped):
      state.local.alertDoubleButtonAlert = nil
      return .none

    case .cardResult:
      return .none

    case .alertDoubleButtonAlert:
      return .none

    case .presentToast:
      return .none
    }
  }
])

private func setAlertModal(
  state: inout AlertDoubleButtonState?,
  titleText: String? = nil,
  bodyText: String,
  secondaryButtonTitle: String,
  secondaryButtonHierachy: AlertButton.Hierarchy = .secondary,
  primaryButtonTitle: String,
  primaryButtonHierachy: AlertButton.Hierarchy = .primary
) -> Effect<SearchResultDetailAction, Never> {
  state = .init(
    title: titleText,
    body: bodyText,
    secondaryButtonTitle: secondaryButtonTitle,
    secondaryButtonHierachy: secondaryButtonHierachy,
    primaryButtonTitle: primaryButtonTitle,
    primaryButtonHierachy: primaryButtonHierachy
  )
  return .none
}
